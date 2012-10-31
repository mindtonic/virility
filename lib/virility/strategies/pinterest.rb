module Virility
	class Pinterest < Strategy

	  parser(
	    Proc.new do |body, format|
	      MultiJson.decode(body.scan(/(\{.+\})/).flatten.first)
	    end
	  )

		def census
			self.class.get("http://api.pinterest.com/v1/urls/count.json?url=#{@url}")
		end

		def count
			results["count"] || 0
		end

	end
end