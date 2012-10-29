# http://stackoverflow.com/questions/7403553/how-do-i-get-the-counter-of-a-google-plus-1-button
module Virility
	class PlusOne < Context
	
	  parser(
	    Proc.new do |body, format|
	    	{'shares' => body.scan(/c: (\d+)/).flatten.first}
	    end
	  )
	
		def get_virility
			@response = self.class.get("https://plusone.google.com/_/+1/fastbutton?url=#{@url}")
			@counts = @response.parsed_response
		end
	
	end
end