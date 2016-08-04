module Virility
  class Facebook < Strategy
    BASE_URL = "https://api.facebook.com/method/links.getStats?urls="
    def census
      self.class.get("#{BASE_URL}#{@url}")
    end

    def outcome
      @response.parsed_response["links_getStats_response"]["link_stat"]
    end

    def count
      results["total_count"] || 0
    end

  private

    def valid_response_test
      @response.respond_to?(:parsed_response) and @response.parsed_response.is_a?(Hash) and !@response.parsed_response["links_getStats_response"].nil? and !@response.parsed_response["links_getStats_response"]["link_stat"].nil?
    end

  end
end
