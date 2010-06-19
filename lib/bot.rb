require "rubygems"

require 'active_record' # db
require 'feedzirra' # feed helper
require 'yaml'
require 'twitter'
require File.join(File.dirname(__FILE__), 'hash')

class Tweets < ActiveRecord::Base
end

###
#  What we want the bot to do
###
#  1. Listen to an rss feed and store that stuff
#  2. Work out which tweets need to be tweeted by the bot
#  3. send the tweets and mark them as 'tweeted'
#  4. repeat ad nauseam every x seconds (as indicated, 180 is recommended)
#

class HashtagRetweetBot
  def initialize(tag, seconds=180)
    @tag = tag
    @seconds = seconds
    @client = nil
  end
  
  def authorize
    if(File.exist?('config/oauth.yml'))
      puts "Found config/oauth.yml, using OAuth."
      authorize_using_oauth
    elsif(File.exist?('config/bot.yml'))
      puts "Using HTTP Auth (DEPRECATED)."
      authorize_using_httpauth
    else
      puts "No config file (neither oauth.yml nor bot.yml) found in config/, exiting..."
      exit
    end
  end
  
  def authorize_using_oauth
    oauth_config = YAML.load(File.open('config/oauth.yml') { |f| f.read }).symbolize_keys!
    oauth = Twitter::OAuth.new(oauth_config[:consumer][:token], oauth_config[:consumer][:secret])
    oauth.authorize_from_access(oauth_config[:access][:token], oauth_config[:access][:secret])
    
    @client = Twitter::Base.new(oauth)
    puts "Logged in successfully using OAuth, bot should be working now."
    #@client.update("Heyo from OAuth app at #{Time.now}")
  rescue Twitter::Unauthorized
    puts "It seems the access token are no longer valid, we need to get new ones."
    regenerate_oauth(oauth_config)
  end
  
  def authorize_using_httpauth
    http_config = YAML.load(File.open('config/bot.yml') { |f| f.read }).symbolize_keys!
    httpauth = Twitter::HTTPAuth.new(http_config[:login], http_config[:password])
    @client = Twitter::Base.new(httpauth)
    puts "Logged in successfully using HTTP Auth, bot should be working now."
    #@client.update("Heyo from HTTP Auth app at #{Time.now}")
  end
  
  def regenerate_oauth(oauth_config)
    oauth = Twitter::OAuth.new(oauth_config[:consumer][:token], oauth_config[:consumer][:secret])
    request_token = oauth.request_token
    puts request_token.authorize_url
    puts "Visit the above link, grant access and type in PIN: "
    STDOUT.flush
    pin = STDIN.gets.chomp
    access_token = request_token.get_access_token(:oauth_verifier => pin)
    
    oauth_config[:access] = {:token => access_token.token, :secret => access_token.secret}
    
    File.open('config/oauth.yml', 'w') { |f| YAML.dump(oauth_config, f)}
    puts "New access token saved, please re-run the bot."
  end
    

  def run
    authorize

    adapter_attrs = YAML.load(File.open('config/database.yml') { |f| f.read })
    ActiveRecord::Base.establish_connection(adapter_attrs)

    feed_thread = Thread.new do
      while(true != false)
        begin
          # fetch the feed
          feed = get_tweets_tagged_with(@tag)
          feed.entries.reverse.each do |entry|
            tweet = Tweets.find_or_create_by_twitter_id(
                      :twitter_id => entry.id,
                      :published  => entry.published,
                      :title      => entry.title,
                      :content    => entry.content,
                      :link       => entry.url
                    )

            if tweet.tweeted.blank?
              origin = tweet.link.gsub(/^http.*com\//,"").gsub(/\/statuses\/\d*/,"")
              # strip the whole tag at the end of the tweet (since it is just for tagging)
              message = tweet.title.gsub(%r{#(#{@tag})\s*$}i, '').rstrip
              # strip only the # anywhere else (since it is part of the tweet)
              message = message.gsub(%r{#(#{@tag})}i, '\1')
              if origin.size + message.size  <= 130
                @client.update("RT @#{origin}: #{message}")
              else
                @client.update("RT @#{origin} tagged '#{@tag}': #{tweet.link}")
              end
              puts "#{Time.now.to_s(:long)}" # poor mans logging
              tweet.update_attribute(:tweeted, true)
            end
          end
        rescue
        end
        sleep(@seconds)
      end
    end

    feed_thread.join
  end

  private
  def get_tweets_tagged_with(tag)
    Feedzirra::Feed.fetch_and_parse("http://search.twitter.com/search.atom?q=+%23#{tag}")
  end

end # class

