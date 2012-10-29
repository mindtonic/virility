module Virility
	class StumbleUpon < Context

	  parser(
	    Proc.new do |body, format|
	      MultiJson.decode(body)
	    end
	  )
	
		def get_virility
			@response = self.class.get("http://www.stumbleupon.com/services/1.01/badge.getinfo?url=#{@url}")
			@counts = @response.parsed_response
		end
	
	end
end