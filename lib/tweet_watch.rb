require "tweet_watch/version"
require "tweet_watch/config"
require "tweet_watch/follower"
require "twitter"
require "yaml"

module TweetWatch
  
  def self.root
      File.dirname __dir__
  end
  
  def self.run
    c = Config.new
    # f = Follower.new("ajoabraham",
#       "17609705-Fd9WcmbEEFFftEwxxFvF1FOgtZ1S4E1YNnj0XcPyc",
#       "VIge9jyWlz9k9qe0jVK3gHoSwqMlgsi0cRZwZEYpWXu6G")
#
#     client = Twitter::REST::Client.new do |config|
#       config.consumer_key        = @config[:consumer_key]
#       config.consumer_secret     = @config[:consumer_secret]
#       config.access_token        = f.access_token
#       config.access_token_secret = f.access_token_secret
#     end
#
#     client.home_timeline.each do |ht|
#       quoted = ht.quoted_status_id if ht.respond_to? :quoted_status_id
#       reply = ht.in_reply_to_status_id if ht.respond_to? :in_reply_to_status_id
#       puts "#{ht.id}, #{ht.full_text}, #{ht.created_at}, #{ht.favorite_count}, #{ht.user.screen_name}, #{ht.user.name}, #{quoted}, #{reply}"
#
#     end
    
  end
end
