require 'cgi'
require 'httparty'

require 'virility/version'
require 'virility/supporter'
require 'virility/excitation'
require 'virility/context'

Dir["#{File.dirname(__FILE__)}/virility/strategies/**/*.rb"].each {|f| require f}

module Virility
	class UnknownStrategy < StandardError; end
end
