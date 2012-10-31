module Virility
	class Twitter < Strategy
	
		def census
			self.class.get("http://urls.api.twitter.com/1/urls/count.json?url=#{@url}")
		end
		
		def count
			results["count"] || 0
		end
	
	end
end