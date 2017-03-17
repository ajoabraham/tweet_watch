module TweetWatch
  module Client
    
    def config
      tw_config = TweetWatch::config
      
      unless tw_config.valid?
        # try to load a local config.yml
        puts "trying to load config from current directory..."
        path = 'config.yml'
        if File.exists?(path)
          tw_config.load_from_path(path)
        else
          raise ArgumentError.new("Invalid configuration: " + tw_config.error_message)
        end
      end
      
      tw_config
    end
    
    def client(screen_name = nil)
      tw_config = config
      user = get_user(screen_name)
            
      @client ||= Twitter::REST::Client.new do |config|
        config.consumer_key        = tw_config.consumer_key
        config.consumer_secret     = tw_config.consumer_secret
        config.access_token        = user.access_token
        config.access_token_secret = user.access_token_secret
      end
    end
    
    def streaming_client(screen_name = nil)
      tw_config = config   
      user = get_user(screen_name)
         
      @client ||= Twitter::Streaming::Client.new do |config|
        config.consumer_key        = tw_config.consumer_key
        config.consumer_secret     = tw_config.consumer_secret
        config.access_token        = user.access_token
        config.access_token_secret = user.access_token_secret
      end
    end
    
    def load_config(path)
      TweetWatch::config.load_from_path(path)
    end
    
    def get_user(screen_name)
      user = config.users.first
      
      unless screen_name.nil?
        res = config.users.select { |u| u.screen_name.strip() == screen_name.strip() }
        user = res.first if res.size > 0
      end
      
      return user
      
    end
    
  end
  
end