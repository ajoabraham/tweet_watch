# TweetWatch

TweetWatch can be used to collect timeline data from several accounts and from specific twitter users.  The primary motivation for creating this gem was to track the home timeline of several accounts and study how and when tweets appear in an accounts timeline.  Is shadow banning real?

This gem is designed to be used as CLI tool but is not a full fledged alternative to the [twitter CLI](https://github.com/sferik/t).  The primary goal of this gem is to collect twitter data perodically.

![Image of TweetWatch timeline streaming](https://raw.githubusercontent.com/ajoabraham/tweet_watch/master/timeline_streaming.png)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'tweet_watch'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install tweet_watch

## Configuration

All CLI commands require a configuration file.  The config file has two major sections **accounts** and **tweeters**.  Tweeters are the accounts you want to track.  This is optional and will cause the csv output to only contain tweets from one of these users.  Accounts is where you define access to a twitter account. More on that below.

See example [config.yml](config.yml). 

## Account Authorization

To give TweetWatch access to your home timeline, register a twitter app and enter the accounts credentials in your config file. 
1. Go to [Twitter Apps Site](https://apps.twitter.com/)
2. Click on "Create a New App", if you don't already have one. (You can have more than one)
3. In your App, click on the "Keys and Access Tokens" tab
4. Scroll down and generate access token and secret
5. Add an account to your config file as shown in the [example](config.yml).  For each account enter the screen name, consumer key, consumer secret, access token, access secret

Now you're ready to use tweet_watch

## Usage

Get the last 50 tweets in an accounts home timeline:

```sh
tweet_watch timeline -c config.yml
```

Get the last 100 twets for a specfic account in your config file:

```sh
tweet_watch timeline -c config.yml -n 100 -u ajoabraham
```

Instead of printing out a timeline stream it:

```sh
tweet_watch timeline -c config.yml -s
```

Stream a timeline and record to a CSV file tweets from specific users.  Tweeters list can be provided from the command line or read in from the Config file:

```sh
tweet_watch watch -c config.yml -t user1 user2 user3
```

Monitor the home timeline of configured accounts while also recording the tweets sent by the provided list of tweeters:
```sh
tweet_watch monitor -c config.yml
```

The monitor command by default will run every 15 minutes but you can provide a different interval by passing _-i_ command with your desired time in seconds.  This will create a tweeter_tweets.csv and account_timeline.csv file.  Comparing the data in these files we should be able to determine how and when tweets will get propagated into home timelines of target accounts.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/ajoabraham/tweet_watch. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

