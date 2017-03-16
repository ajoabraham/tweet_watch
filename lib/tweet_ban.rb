require "tweet_ban/version"
require "tweet_ban/follower"
require "twitter"

module TweetBan
  
  @config = {
    consumer_key: "jKgFRB9dogVmyRB1P4Wm5J7CN",
    consumer_secret: "oMswt4MMBJxrtfQ27JkmbuLfHMvkZKrlSpIcT8AdmubJcSjlpT"
  }
  
  def self.run
    f = Follwer.new("ajoabraham", 
      "17609705-Fd9WcmbEEFFftEwxxFvF1FOgtZ1S4E1YNnj0XcPyc",
      "VIge9jyWlz9k9qe0jVK3gHoSwqMlgsi0cRZwZEYpWXu6G")
      
    client = Twitter::REST::Client.new do |config|
      config.consumer_key        = @config.consumer_key
      config.consumer_secret     = @config.consumer_secret
      config.access_token        = f.access_token
      config.access_token_secret = f.access_secret_token
    end
    
    client.home_timeline.each do |ht|
      puts ht
    end
    
  end
end
