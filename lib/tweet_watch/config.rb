module TweetWatch
  class Config
    attr_accessor :count, :accounts, :tweeters
    
    attr_reader :error_message
    
    def initialize
      @accounts = []
      @tweeters = []
      @count = 50
      @error_message = ""
    end
    
    def load_from_path(config_path)
      c = YAML.load_file(config_path)
                  
      unless c["accounts"].nil?
        c["accounts"].each do |f|
          self.accounts << Account.new(f["screen_name"], 
            f["consumer_key"], f["consumer_secret"],
            f["access_token"], f["access_token_secret"])
        end        
      end
      
      unless c["tweeters"].nil?
        c["tweeters"].each do |t|
          self.tweeters << t
        end        
      end
      
      self
    end
    
    def valid?
      @error_message = ""
      @error_message += "There should be at least one account" if accounts.size ==0
      @error_message.strip().length == 0
    end
    
  end
end