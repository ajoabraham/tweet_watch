module TweetWatch
  class Config
    attr_accessor :count, :accounts, :tweeters, :path
    
    attr_reader :error_message
    
    def initialize
      @accounts = []
      @tweeters = []
      @count = 50
      @error_message = ""
    end
    
    def load_from_path(path)
      unless File.exists?(path)
        raise ArgumentError.new("The provided config file could not be located: #{path}")
      end
      
      @path = path
      c = YAML.load_file(@path)
                  
      unless c["accounts"].nil?
        c["accounts"].each do |f|
          self.accounts << Account.new(f["screen_name"], 
            f["consumer_key"], f["consumer_secret"],
            f["access_token"], f["access_token_secret"])
        end        
      end
      
      unless c["tweeters"].nil?
        c["tweeters"].each do |t|
          self.tweeters << t unless has_tweeter?(t)
        end        
      end
      
      self
    end
    
    def has_tweeter?(tweeter)
      res = @tweeters.find{|t| t.downcase.strip == tweeter.downcase.strip }
      res != nil
    end
    
    def valid?
      @error_message = ""
      @error_message += "There should be at least one account" if accounts.size ==0
      @error_message.strip().length == 0
    end
    
    def get_account(screen_name = nil)
      account = @accounts.first
      
      unless screen_name.nil?
        res = @accounts.select { |u| u.screen_name.strip() == screen_name.strip() }
        account = res.first if res.size > 0
      end
      
      return account
      
    end
    
  end
end