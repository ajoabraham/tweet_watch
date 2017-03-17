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
    
    
  end
  
end