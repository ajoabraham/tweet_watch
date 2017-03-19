module TweetWatch
  module Client
    
    def client(options)
      account = get_account(options[:screen_name])
            
      @client ||= Twitter::REST::Client.new do |config|
        config.consumer_key        = account.consumer_key
        config.consumer_secret     = account.consumer_secret
        config.access_token        = account.access_token
        config.access_token_secret = account.access_token_secret
      end
    end
    
    def streaming_client(options)
      account = get_account(options[:screen_name])
         
      @client ||= Twitter::Streaming::Client.new do |config|
        config.consumer_key        = account.consumer_key
        config.consumer_secret     = account.consumer_secret
        config.access_token        = account.access_token
        config.access_token_secret = account.access_token_secret
      end
    end
    
    def load_config(path)
      if path.respond_to?(:keys) && path[:config]
        TweetWatch::config.load_from_path(path[:config])
      elsif path.class == String
        TweetWatch::config.load_from_path(path)
      end
    end
    
    def get_account(screen_name)
      load_config(options)
      account = TweetWatch.config.accounts.first
      
      unless screen_name.nil?
        res = TweetWatch.config.accounts.select { |u| u.screen_name.strip() == screen_name.strip() }
        account = res.first if res.size > 0
      end
      
      return account
      
    end
    
  end
  
end