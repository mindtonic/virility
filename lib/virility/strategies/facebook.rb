module Virility
	class Facebook < Context
		BASE_URL = "https://api.facebook.com/method/fql.query?query=SELECT+share_count%2C+like_count%2C+comment_count%2C+total_count%2C+commentsbox_count%2C+click_count+FROM+link_stat+WHERE+url%3D"

		def poll
			@response = self.class.get("#{BASE_URL}%22#{@url}%22")
			@results = @response.parsed_response["fql_query_response"]["link_stat"]
		end
		
		def count
			results["total_count"] || 0
		end
	end
end