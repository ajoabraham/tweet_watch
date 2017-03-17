module TweetWatch
  
  class User
    attr_accessor :screen_name, :access_token, :access_token_secret
    
    def initialize(screen_name, token, secret)
      @screen_name = screen_name
      @access_token = token
      @access_token_secret = secret      
    end
    
  end
  
end
