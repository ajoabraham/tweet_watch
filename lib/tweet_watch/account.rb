module TweetWatch
  
  class Account
    attr_accessor :screen_name, :access_token, :access_token_secret,
                  :consumer_key, :consumer_secret
    
    def initialize(screen_name, consumer_key, 
                    consumer_secret, access_token, 
                    access_token_secret)
                    
      @screen_name = screen_name
      @consumer_key = consumer_key
      @consumer_secret = consumer_secret
      @access_token = access_token
      @access_token_secret = access_token_secret      
    end
    
  end
  
end
