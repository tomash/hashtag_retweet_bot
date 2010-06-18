require "rubygems"
require "bundler"
Bundler.setup

require 'twibot' # our bot helper
require 'active_record' # db
require 'feedzirra' # feed helper
require 'yaml'

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
  end

  def run

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
              if origin.size + message.size  <= 135
                twitter.status(:post, "RT @#{origin}: #{message}")
              else
                twitter.status(:post, "RT @#{origin} tagged '#{@tag}': #{tweet.link}")
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

