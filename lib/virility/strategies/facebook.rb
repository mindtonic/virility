module Virility
	class Facebook < Strategy
		BASE_URL = "https://api.facebook.com/method/fql.query?query=SELECT+share_count%2C+like_count%2C+comment_count%2C+total_count%2C+commentsbox_count%2C+click_count+FROM+link_stat+WHERE+url%3D"

		def poll
			@response = self.class.get("#{BASE_URL}%22#{@url}%22")
			@results = valid_response_test ? @response.parsed_response["fql_query_response"]["link_stat"] : {"total_count" => 0}
		end

		def count
			results["total_count"] || 0
		end
		
	private
	
		def valid_response_test
			@response.respond_to?(:parsed_response) and @response.parsed_response.is_a?(Hash) and !@response.parsed_response["fql_query_response"].nil? and !@response.parsed_response["fql_query_response"]["link_stat"].nil?
		end

	end
end