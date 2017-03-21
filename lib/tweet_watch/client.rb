module TweetWatch
  module Client
    
    def client(options = {})
      return @client if options.nil? && @client  
       
      account = TweetWatch.config.get_account(options[:screen_name])
            
      @client = Twitter::REST::Client.new do |config|
        config.consumer_key        = account.consumer_key
        config.consumer_secret     = account.consumer_secret
        config.access_token        = account.access_token
        config.access_token_secret = account.access_token_secret
      end
    end
    
    def streaming_client(options = {})
      return @client if options.nil? && @client
      
      account = TweetWatch.config.get_account(options[:screen_name])
         
      @client = Twitter::Streaming::Client.new do |config|
        config.consumer_key        = account.consumer_key
        config.consumer_secret     = account.consumer_secret
        config.access_token        = account.access_token
        config.access_token_secret = account.access_token_secret
      end
    end
        
  end
  
end