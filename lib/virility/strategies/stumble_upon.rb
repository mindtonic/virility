module Virility
	class StumbleUpon < Context

	  parser(
	    Proc.new do |body, format|
	      MultiJson.decode(body)["result"]
	    end
	  )
	
		def census
			self.class.get("http://www.stumbleupon.com/services/1.01/badge.getinfo?url=#{@url}")
		end
		
		def count
			results["views"] || 0
		end
	
	end
end