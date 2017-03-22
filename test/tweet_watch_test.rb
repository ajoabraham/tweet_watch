require 'test_helper'

class TweetWatchTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::TweetWatch::VERSION
  end

  def test_it_does_something_useful
    assert true
  end
  
  def test_can_configure
    TweetWatch.configure do |config|
      config.tweeters = ["scottadamsays", "jaketapper", "potus"]
      config.accounts << TweetWatch::Account.new("crenditialedaccount", "consumerkey", "consumersecret", "accesskey", "accesssecret")
    end    
  end
  
  def test_load_config_from_file
    c = TweetWatch::Config.new
    c.load_from_path(File.join(File.dirname(__dir__), 'config.yml' ))
    
    assert !c.accounts.first.consumer_key.nil?
    assert !c.accounts.first.consumer_secret.nil?
    assert_equal 4,c.tweeters.size, "should have 2 tweeters in config file"
    assert_equal 2,c.accounts.size,"should have 2 followers in config file"
  end
  
  def test_config_validation
     c = TweetWatch::Config.new
     assert !c.valid?, "should not be valid due to missing account"
       
     c.accounts << TweetWatch::Account.new("crenditialedaccount", "consumerkey", "consumersecret", "accesskey", "accesssecret")
     assert c.valid?, "should be valid"
  end
  
end
