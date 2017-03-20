require 'colorize'

module TweetWatch
    
  class CLI < Thor
    include Client
    include Utils
    
    class_option :screen_name, aliases: "-u", 
            desc: "The screename of the account. If not included, will select the first account from the config file."
    class_option :config_file, aliases: "-c",  required: true,
                    desc: "Yaml config file path"
    
          
    desc "limits", "Print out the current rate limits"
    def limits
      load_config(options)
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
    
    desc "timeline", "Prints out an accounts timeline"
    option :stream, aliases: "-s", 
            desc: "Will stream a tweets as they come in instead of printing the latest timeline."
    option :count, aliases: "-c", default: 50, type: :numeric,
            desc: "Number of past tweets to print out. Max history is 200"
    def timeline
      load_config(options)
      
      if options[:stream]
        sc = streaming_client(options)
        puts "Starting stream...".colorize(:light_cyan)
        sc.user do |obj|
          if obj.class == Twitter::Tweet
            print_tweet obj
          elsif obj.class == Twitter::DirectMessage
            print_dm obj
          end
        end
      else
        client(options).home_timeline.each do |tw|
          print_tweet(tw)
        end
      end 
      
    end    
    
    desc "watch", "Watches a stream and records tweets. Filter which tweets are recorded by providing a tweeters list."
    option :output, aliases: "-o", 
            desc: "output file - will append if files exists", default: "tweet_watch.csv"
    option :tweeters, aliases: "-t", type: :array,
            desc: "list of tweeters to filter recorded tweets by"
    option :tweeters_only, aliases: "-f",
            desc: "only prints to screen provided list of tweeters"
    def watch
      load_config(options)
              
      sc = streaming_client(options)
      file = File.open(options[:output], "a+")
      tw_config = TweetWatch.config
      
      tweeters = options[:tweeters] ? options[:tweeters] : tw_config.tweeters
      
      unless file.size > 0
        file.puts "timelined_at, tweet_id, screen_name, text, tweet_created_at, is_reply, is_quote"
      end
            
      puts "Starting stream...".colorize(:light_cyan)
      sc.user do |obj|
        time = Time.now
        
        if obj.class == Twitter::Tweet          
          if options[:tweeters_only].nil? || (options[:tweeters_only] && tweeters.include?(obj.account.screen_name))
            print_tweet obj
          end
          
          if tw_config.tweeters.empty? || tweeters.include?(obj.user.screen_name)
            puts "recording tweet data".colorize(:red)            
            file.puts "#{time.utc}, #{obj.id}, \"#{escape_str(obj.user.screen_name)}\", \"#{escape_str(obj.text)}\", #{obj.created_at.getutc},\"#{escape_str(obj.user.screen_name)}\", #{obj.reply?}, #{obj.quote?}"
          end
        elsif obj.class == Twitter::DirectMessage
          print_dm obj
        elsif obj.class == Twitter::Streaming::StallWarning
          warn "Falling behind!"
        else
          puts "untracked tweet obj #{obj.class}".colorize(color: :black, background: :light_white)
        end
      
      end
    end
    
  end
  
end