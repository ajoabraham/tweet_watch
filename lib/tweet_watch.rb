require "twitter"
require "yaml"
require 'thor'

require "tweet_watch/version"
require "tweet_watch/config"
require "tweet_watch/user"
require "tweet_watch/client"
require "tweet_watch/cli"


module TweetWatch
  class << self
    attr_writer :config
  end

  def self.config
    @config ||= Config.new
  end

  def self.reset
    @config = Config.new
  end

  def self.configure
    yield(config)
  end  
  
  def self.root
      File.dirname __dir__
  end  
  
    
end
