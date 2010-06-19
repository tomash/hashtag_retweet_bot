# Hashtag retweet bot

A bot that retweets all tweets tagged by a certain hashtag. Ideal for conferences, meetup groups, communities, etc.

As an example, let's say you want to retweet every tweet found with the hashtag #icecream every 5 minutes (300 seconds). This ruby gem will let you do it as easily as running:

    hashtag_retweet_bot icecream 300

## Installation

    gem install hashtag_retweet_bot

Create the database:

    mysqladmin create my_conference_db

Create a directory where you will run the bot from, and a config directory with 2 files in it: _database.yml_ for your database settings and either
* _oauth.yml_ to make the bot use OAuth (RECOMMENDED)
* _bot.yml_ for the login/password of the twitter account (DEPRECATED)

    mkdir -p bot_for_my_conference/config
    cd config/bot_for_my_conference
    touch database.yml
    
If you want to use OAuth, register a new application on Twitter and put in consumer key (token) and secret in _oauth.yml_:
    consumer:
      token: my_apps_consumer_key
      secret: my_apps_consumer_secrets
      
Don't worry now about request and access token/secret pairs, the bot will guide you the first time you launch it. And every time access token/secret will become invalid and need re-creating (as of June 2010, Twitter is not expiring access tokens, but they can be invalidated by removing the app).

If you want to use HTTP Auth (it's DEPRECATED by Twitter and will be no longer supported after August 2010), put the credentials for the twitter account in _bot.yml_:

    login: my_conference_bot
    password: secret

Put the database connection attributes in _database.yml_:

    adapter: mysql
    username: root
    host: localhost
    password:
    database: my_conference_db

And create the table on the database that will hold the tweets:

    hashtag_retweet_bot create_db_table

## Run it

Now the only thing left to do is running the bot, telling it what tag to follow, like that:

    hashtag_retweet_bot tag_to_follow

This will launch the bot with a default pause of 180 seconds. If you want a different time schedule you can specify other value for the seconds parameter, but I've experienced Twitter connection problems when trying to update every 60 seconds or less:

    hashtag_retweet_bot tag_to_follow seconds_between_updates

Example:

    hashtag_retweet_bot icecream
    hashtag_retweet_bot icecream 240

## Live examples

Some twitterbots using hashtag_retweet_bot:

* [@euruko_bot](http://twitter.com/euruko_bot)
* [@confrorbot](http://twitter.com/confrorbot)
* [The bot for the Budapest Ruby User Group](http://twitter.com/budapestrb)

## Credits

Original idea and script by [Mark Connell](http://github.com/mconnell) for Scotland on Rails 2009. Customization for Euruko '09, and some improvements by [Jaime Iniesta](http://github.com/jaimeiniesta). Some improvements and gemification by [Balint Erdi](http://github.com/balinterdi).
Customization for Euruko '10 and further work (OAuth support, refactoring etc.) by [Tomasz Stachewicz](http://github.com/tomash) 

Please send feedback and bug reports to <balint.erdi@gmail.com>