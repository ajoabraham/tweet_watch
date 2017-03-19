require 'colorize'

module TweetWatch
  
  def self.print_tweet(tw)
      puts "\n---".colorize(:light_red)
      puts "#{tw.user.name} (@#{tw.user.screen_name})".colorize(:light_yellow) + " FW: #{tw.user.followers_count}".colorize(:green)
      puts tw.text.colorize(:light_cyan)
      puts "#{(Time.now - tw.created_at).round(2)} secs ago".colorize(:light_red) +" RT: #{tw.retweet_count} LK: #{tw.favorite_count}\n".colorize(:green)
  end
  
  class CLI < Thor
    include Client
    
    class_option :screen_name, aliases: "-u", 
            desc: "The screename of the account. If not included, will select the first account from the config file."
    class_option :config, aliases: "-c", 
                    desc: "Yaml config file path"
    
          
    desc "limits", "Print out the current rate limits"
    def limits
      resp = Twitter::REST::Request.new(client, 'get', "/1.1/application/rate_limit_status.json" ).perform
      
      current_time = Time.now.to_i
      template = "   %-40s %5d remaining, resets in %3d seconds\n"
      resp.body[:resources].each do |category,resources|
        puts category.to_s
        resources.each do |resource,info|
          printf template, resource.to_s, info[:remaining], info[:reset] - current_time
        end
      end
    end
    
    desc "timeline", "Prints out an accounts timeline. Recent 20 tweets."
    option :stream, aliases: "-s", 
            desc: "Will stream a tweets as they come in instead of printing the latest timeline."
    def timeline
      if options[:stream]
        sc = streaming_client(options)
        puts "Starting stream...".colorize(:light_cyan)
        sc.user do |obj|
          if obj.class == Twitter::Tweet
            TweetWatch.print_tweet obj
          end
        end
      else
        client(options).home_timeline.each do |tw|
          TweetWatch.print_tweet(tw)
        end
      end 
      
    end    
    
    desc "watch", "Watches a stream and records tweets. Filter which tweets are recorded by providing a tweeters list."
    option :output, aliases: "-o", 
            desc: "output file - will append if files exists", default: "tweet_watch.csv"
    option :tweeters, aliases: "-t", type: :array,
            desc: "list of tweeters to filter recorded tweets by"
    option :tweeters_only, aliases: "-to",
            desc: "only prints to screen provided list of tweeters"
    def watch        
      file = File.open(options[:output], "a+")
      tw_config = TweetWatch.config
      
      tweeters = options[:tweeters] ? options[:tweeters] : tw_config.tweeters
      
      unless file.size > 0
        file.puts "timelined_at, tweet_id, screen_name, text, tweet_created_at, is_reply, is_quote"
      end
      
      sc = streaming_client(options)
      puts "Starting stream...".colorize(:light_cyan)
      sc.user do |obj|
        time = Time.now
        if obj.class == Twitter::Tweet
          
          if options[:tweeters_only].nil? || (options[:tweeters_only] && tweeters.include?(obj.account.screen_name))
            TweetWatch.print_tweet obj
          end
          
          if tw_config.tweeters.empty? || tweeters.include?(obj.account.screen_name)
            puts "recording tweet data"            
            file.puts "\"#{time.utc}\", \"#{obj.id}\", \"#{obj.account.screen_name}\", \"#{obj.text}\", \"#{obj.created_at.getutc}\",\"#{obj.account.screen_name}\", \"#{obj.reply?}\", \"#{obj.quote?}\""
          end
          
        end
      end
    end
    
  end
  
end