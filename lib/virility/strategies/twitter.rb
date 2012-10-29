module Virility
	class Twitter < Context
	
		def get_virility
			@response = self.class.get("http://urls.api.twitter.com/1/urls/count.json?url=#{@url}")
			@counts = @response.parsed_response
		end
	
	end
end