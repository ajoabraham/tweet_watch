module TweetWatch
  
  module Utils
    def load_config(options)
      if options[:config_file]
        TweetWatch.config.load_from_path(options[:config_file])
      else
        TweetWatch.config.load_from_path("config.yml")
      end
    end
    
    def escape_str(str)
      str2 = str.gsub('"', '\"')
      str2.gsub(/\\(.)/) do |s|
        case $1
        when "n"
          "\n"
        when "t"
          "\t"
        else
          $1
        end
      end      
    end  
    
    def print_tweet(tw)
        puts "\n---".colorize(:light_red)
        puts "#{tw.user.name} (@#{tw.user.screen_name})".colorize(:light_yellow) + " FW: #{tw.user.followers_count}".colorize(:green)
        puts tw.text.colorize(:light_cyan)
        puts "#{(Time.now - tw.created_at).round(2)} secs ago".colorize(:light_red) +" RT: #{tw.retweet_count} LK: #{tw.favorite_count}\n".colorize(:green)
    end
  
    def print_dm(tw)
        puts "\nDM --- DM".colorize(color: :light_white, background: :red)
        puts "#{tw.sender.name} (@#{tw.sender.screen_name})".colorize(color: :light_yellow, background: :red) + " FW: #{tw.sender.followers_count}".colorize(color: :green, background: :red)
        puts tw.text.colorize(color: :white, background: :red)
        puts "#{(Time.now - tw.created_at).round(2)} secs ago".colorize(color: :yellow, background: :red)
    end
    
  end
  
end