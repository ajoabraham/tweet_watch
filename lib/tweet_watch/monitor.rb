require 'csv'
require 'tweet_watch/utils'
require 'tweet_watch/client'

module TweetWatch
  
  class Monitor
    
    include TweetWatch::Client
    include TweetWatch::Utils
    
    def initialize(options = {})
      @options = {interval: (15*60), 
                  initial_tweet_history: 200,
                  timeline_count: 200}
      @options.merge!(Hash[options.map{ |k, v| [k.to_sym, v] }])      
      @options[:interval] = @options[:interval].to_i
      
      @new_tweeter_tweets = 0
      
      if TweetWatch.config.tweeters.empty?
        raise ArgumentError.new("Monitor requires list of target tweeters. Please update config")
      end
      
      if TweetWatch.config.accounts.empty?
        raise ArgumentError.new("Monitor requires at least one account. Please update config")
      end
      
      @tweeter_state = {}
    end
    
    def run
      TweetWatch.config.tweeters.each do |tweeter|
        record_user_tweets(tweeter)
        sleep(1)
      end
      
      if @new_tweeter_tweets > 0
        TweetWatch.config.accounts.each do |account|
          record_timeline(account)
        end
      end
      
      @new_tweeter_tweets = 0
      
      sleep(@options[:interval])      
      self.run
    end
    
    private
    
    def record_timeline(account)
      puts "recording timeline for @#{account.screen_name}..."
      
      c = client({screen_name: account.screen_name})
      time = Time.now.utc
      timeline = c.home_timeline({count: @options[:timeline_count]})
      
      file = CSV.open("account_timeline.csv", "a+")
      unless File.size("account_timeline.csv") > 0
        file << %W(recorded_at tweet_id screen_name text tweet_created_at timeline_account is_reply is_quote)
      end
      
      timeline.each do |obj|
        file << [time, obj.id, obj.user.screen_name, obj.text,obj.created_at.getutc,account.screen_name, obj.reply?, obj.quote?]
      end
      
      file.close  
    end
    
    def record_user_tweets(tweeter)
      puts "collecting @#{tweeter} tweets..."
      time = Time.now.utc
      
      opts = {count: @options[:initial_tweet_history]}
      if @tweeter_state[tweeter]
        opts[:since_id] = @tweeter_state[tweeter]
      end
      
      timeline = client.user_timeline(tweeter,opts)
      
      file = CSV.open("tweeter_tweets.csv", "a+")
      unless File.size("tweeter_tweets.csv") > 0
        file << %W(recorded_at tweet_id screen_name text tweet_created_at is_reply is_quote)
      end
      
      @new_tweeter_tweets += timeline.size
      timeline.each do |obj|
        file << [time, obj.id, obj.user.screen_name, obj.text,obj.created_at.getutc, obj.reply?, obj.quote?]
      end
      
      @tweeter_state[tweeter] = timeline.first.id if timeline.size > 0
      puts "New tweets since last checking? : #{@new_tweeter_tweets}"
      file.close 
    end
    
  end
  
end