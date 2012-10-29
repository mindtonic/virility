module Virility
	class Delicious < Context
	
		def get_virility
			@response = self.class.get("http://feeds.delicious.com/v2/json/urlinfo/data?url=#{@url}")
			@counts = @response.parsed_response.first
		end
	
	end
end