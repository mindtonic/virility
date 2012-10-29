module Virility
	class StumbleUpon < Context

	  parser(
	    Proc.new do |body, format|
	      MultiJson.decode(body)["result"]
	    end
	  )
	
		def poll
			@response = self.class.get("http://www.stumbleupon.com/services/1.01/badge.getinfo?url=#{@url}")
			@results = @response.parsed_response
		end
		
		def count
			@results["views"] || 0
		end
	
	end
end