require 'cgi'
require 'httparty'
require 'json'

require "virility/version"
require 'virility/excitation'
require 'virility/context'
Dir["#{File.dirname(__FILE__)}/virility/strategies/**/*.rb"].each {|f| require f}

module Virility
  # Your code goes here...
end
