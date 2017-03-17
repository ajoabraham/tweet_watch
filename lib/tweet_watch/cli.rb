module TweetWatch
  
  def self.print_tweet(tw)
      puts "\n---"
      puts "from: @#{tw.user.screen_name}"
      puts tw.text
      puts "created #{Time.now - tw.created_at} seconds ago \n"
  end
  
  class CLI < Thor
    include Client
          
    desc "limits", "Print out the current rate limits"
    def limits
      resp = Twitter::REST::Request.new(client, 'get', "/1.1/application/rate_limit_status.json" ).perform
      puts resp.inspect
      current_time = Time.now.to_i
      template = "   %-40s %5d remaining, resets in %3d seconds\n"
      resp.body[:resources].each do |category,resources|
        puts category.to_s
        resources.each do |resource,info|
          printf template, resource.to_s, info[:remaining], info[:reset] - current_time
        end
      end
    end
    
    desc "timeline", "Prints out the first users timeline. 20 tweets."
    option :s, desc: "will stream the first users timeline"
    option :u, desc: "the screename of the user to authenticate access for"
    def timeline
      if options[:s]
        streaming_client(options[:u]).user do |obj|
          if obj.class == Twitter::Tweet
            TweetWatch.print_tweet obj
          end
        end
      else
        client(options[:u]).home_timeline.each do |tw|
          TweetWatch.print_tweet(tw)
        end
      end 
      
    end    
    
    desc "watch", "Watches a stream to track tweets from specific tweeters"
    option :o, desc: "output file - will append if files exists", default: "tweet_watch.csv"
    option :u, desc: "the screename of the user to authenticate access for"
    def watch        
      file = File.open(options[:o], "a+")
      tw_config = TweetWatch.config
      
      unless file.size > 0
        file.puts "timelined_at, tweet_id, screen_name, text, tweet_created_at, is_reply, is_quote"
      end
      
      streaming_client(options[:u]).user do |obj|
        time = Time.now
        if obj.class == Twitter::Tweet
          TweetWatch.print_tweet obj
          
          if tw_config.tweeters.include?(obj.user.screen_name)
            puts "recording tweet data"            
            file.puts "\"#{time.utc}\", \"#{obj.id}\", \"#{obj.user.screen_name}\", \"#{obj.text}\", \"#{obj.created_at.getutc}\",\"#{obj.user.screen_name}\", \"#{obj.reply?}\", \"#{obj.quote?}\""
          end
          
        end
      end
    end
    
  end
  
end