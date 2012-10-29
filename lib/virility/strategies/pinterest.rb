module Virility
	class Pinterest < Context
	
	  parser(
	    Proc.new do |body, format|
	      MultiJson.decode(body.scan(/(\{.+\})/).flatten.first)
	    end
	  )
	
		def poll
			@response = self.class.get("http://api.pinterest.com/v1/urls/count.json?url=#{@url}")
			@results = @response.parsed_response
		end
		
		def count
			@results["count"] || 0
		end
	
	end
end