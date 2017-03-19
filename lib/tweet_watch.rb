require "twitter"
require "yaml"
require 'thor'

require "tweet_watch/version"
require "tweet_watch/config"
require "tweet_watch/account"
require "tweet_watch/client"
require "tweet_watch/cli"


module TweetWatch
  class << self
    attr_writer :config
    attr_accessor :config_path
  end

  def self.config
    @config ||= Config.new
    return @config if @config.valid?
    
    if config_path
      puts "loading #{config_path} ..."
      path = config_path
    else 
      puts "loading config.yml from current directory..."
      path = 'config.yml'
    end

    if File.exists?(path)
      @config.load_from_path(path)
    else
      raise ArgumentError.new("TweetWatch needs a config.yml file with twitter account info. Could not find one.")
    end
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
