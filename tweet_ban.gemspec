# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'tweet_ban/version'

Gem::Specification.new do |spec|
  spec.name          = "tweet_ban"
  spec.version       = TweetBan::VERSION
  spec.authors       = ["Ajo Abraham"]
  spec.email         = ["abraham.ajo@gmail.com"]

  spec.summary       = %q{Downloads tweets from a twitter account and timelines of select followers of that account.}
  spec.description   = %q{The generated files can be loaded into a database to study twitter throttling behaviour.}
  spec.homepage      = "http://www.veroanalytics.com"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.13"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_dependency "twitter", "~> 6.1"
end
