module TweetWatch
  module Client
    
    def client
      config = TweetWatch::config
      
      unless config.valid?
        # try to load a local config.yml
        path = File.join(File.dirname(__dir__), "config.yml")
        if path
          config.load_from_path(path)
        else
          raise ArgumentError.new("Invalid configuration: " + config.error_message)
        end
      end
  
      @client ||= Twitter::REST::Client.new do |config|
        config.consumer_key        = config.consumer_key
        config.consumer_secret     = config.consumer_secret
        config.access_token        = config.users.first.access_token
        config.access_token_secret = config.users.first.access_token_secret
      end
    end
    
    def load_config(path)
      TweetWatch::config.load_from_path(path)
    end
    
  end
  
end