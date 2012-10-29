module Virility
	class Context
  	include HTTParty
		attr_accessor :url, :response, :results

		def initialize url
			@url = url
		end

		def poll
			raise "Abstract Method poll called on #{self.class} - Please define this method"
		end
	end
end