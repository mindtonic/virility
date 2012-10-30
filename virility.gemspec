# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'virility/version'

Gem::Specification.new do |gem|
  # Details
  gem.name          = "virility"
  gem.version       = Virility::VERSION
  gem.authors       = ["Jay Sanders"]
  gem.email         = ["mindtonic@gmail.com"]
  gem.description   = "Virility leverages the API's of many popular social services to collect data about the virility of a particular URL."
  gem.summary       = "Virility calls upon the API's of many popular social services such as Facebook, Twitter and Pinterest to collect the number of likes, tweets and pins of a particular URL.  Written with a modular construction, Virility makes it easy to drop new data collection strategies into the framework so that you can collect all of your statistics in one easy location."
  gem.homepage      = "http://github.com/mindtonic/virility"
	# Files
  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
  # Development
  gem.add_development_dependency "rspec", "~> 2.6"
  # Dependencies
  gem.add_dependency "httparty", "~> 0.9.0"
end
