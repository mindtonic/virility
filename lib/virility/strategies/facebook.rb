module Virility
  class Facebook < Strategy
    BASE_URL = 'https://graph.facebook.com/?fields=share,og_object{engagement,title}&id='.freeze

    def census
      self.class.get("#{BASE_URL}#{@url}", http_proxyaddr: @http_proxyaddr, http_proxyport: @http_proxyport)
    end

    def outcome
      response = @response.parsed_response.dig('share')
      engagement = @response.parsed_response.dig('og_object', 'engagement')
      response['engagement_count'] = engagement.dig('count')
      response['social_sentence'] = engagement.dig('social_sentence')
      response
    end

    def count
      results.dig('engagement_count') || 0
    end

  private

    def valid_response_test
      @response.respond_to?(:parsed_response) && @response.parsed_response.is_a?(Hash) && !@response.parsed_response['share'].nil?
    end
  end
end
