module Virility
	class Context
  	include HTTParty
		attr_accessor :url, :response, :counts

		def initialize url
			@url = url
		end

		def get_virility
			raise "Abstract Method get_virility called on #{self.class} - Please define this method"
		end
	end
end