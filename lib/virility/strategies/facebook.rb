module Virility
	class Facebook < Context
		BASE_URL = "https://api.facebook.com/method/fql.query?query=SELECT+share_count%2C+like_count%2C+comment_count%2C+total_count%2C+commentsbox_count%2C+click_count+FROM+link_stat+WHERE+url%3D"

		#
		# Interface Methods
		#

		def poll
			@response = self.class.get("#{BASE_URL}%22#{@url}%22")

			if valid_response_test
				@results = @response.parsed_response["fql_query_response"]["link_stat"]
			else
				@results["total_count"] = 0
			end
		end

		def count
			results["total_count"] || 0
		end

		#
		# Facebook Attributes
		#

		def like_count
			result_exists?(:like_count) ? get_result(:like_count) : 0
		end

		def click_count
			result_exists?(:click_count) ? get_result(:click_count) : 0
		end

		def share_count
			result_exists?(:share_count) ? get_result(:share_count) : 0
		end

		def comment_count
			result_exists?(:comment_count) ? get_result(:comment_count) : 0
		end

		def commentsbox_count
			result_exists?(:commentsbox_count) ? get_result(:commentsbox_count) : 0
		end

		def total_count
			result_exists?(:total_count) ? get_result(:total_count) : 0
		end
		
	private
	
		def valid_response_test
			@response.respond_to?(:parsed_response) and @response.parsed_response.is_a?(Hash) and !@response.parsed_response["fql_query_response"].nil? and !@response.parsed_response["fql_query_response"]["link_stat"].nil?
		end

	end
end