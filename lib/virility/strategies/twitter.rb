module Virility
	class Twitter < Context
	
		def poll
			@response = self.class.get("http://urls.api.twitter.com/1/urls/count.json?url=#{@url}")
			@results = @response.parsed_response
		end
		
		def count
			@results["count"] || 0
		end
	
	end
end