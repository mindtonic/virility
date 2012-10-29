module Virility
	class Delicious < Context
	
		def get_virility
			@response = self.class.get("http://feeds.delicious.com/v2/json/urlinfo/data?url=#{@url}")
			@results = @response.parsed_response.first
		end
		
		def count
			@results["total_posts"] || 0
		end
	
	end
end