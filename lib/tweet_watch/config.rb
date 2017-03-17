module TweetWatch
  class Config
    attr_accessor :consumer_key, :consumer_secret, :count, 
      :users, :tweeters
    
    attr_reader :error_message
    
    def initialize
      @users = []
      @tweeters = []
      @count = 50
      @error_message = ""
    end
    
    def load_from_path(config_path)
      c = YAML.load_file(config_path)
      
      unless c["credentials"].nil?
        cc = c["credentials"]
        self.consumer_key = cc["consumer_key"] unless cc["consumer_key"].nil?
        self.consumer_secret = cc["consumer_secret"] unless cc["consumer_secret"].nil?
        self.count = cc["count"] unless cc["count"].nil?
      end
                  
      unless c["users"].nil?
        c["users"].each do |f|
          self.users << User.new(f["screen_name"], f["access_token"], f["access_token_secret"])
        end        
      end
      
      unless c["tweeters"].nil?
        c["tweeters"].each do |t|
          self.tweeters << t
        end        
      end
      
      return c
    end
    
    def valid?
      @error_message = ""
      [:consumer_key, :consumer_secret].each do |m|
        if self.send(m).nil?
          @error_message += "#{m.to_s.capitalize} is missing \n"
        end
      end
      
      @error_message += "There should be at least one user" if users.size ==0
      @error_message.strip().length == 0
    end
    
  end
end