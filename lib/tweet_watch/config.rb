module TweetWatch
  class Config
    attr_accessor :consumer_key, :consumer_secret, :count, 
      :followers, :tweeters, :config_path
    
    def initialize(config_path = nil)
      @followers = []
      @tweeters = []
      @count = 50
      
      if config_path.nil?
        @config_path = File.join TweetWatch.root, "config.yml" 
      else
        @config_path = config_path
      end
    end
    
    private
    
    def load_from_path
     
    end
    
  end
end