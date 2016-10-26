module Virility
  class Facebook < Strategy
    # BASE_URL = "https://api.facebook.com/method/links.getStats?urls="
    BASE_URL = 'https://graph.facebook.com/?fields=share,og_object{engagement,title}&id='.freeze

    def census
      self.class.get("#{BASE_URL}#{@url}")
    end

    def outcome
      response = @response.parsed_response.dig('share')
      engagement = @response.parsed_response.dig('og_object', 'engagement')
      response['engagement_count'] = engagement.dig('count')
      response['social_sentence'] = engagement.dig('social_sentence')
      response
    end

    def count
      results.dig('og_object', 'engagement', 'count') || 0
    end

  private

    def valid_response_test
      @response.respond_to?(:parsed_response) && @response.parsed_response.is_a?(Hash) && !@response.parsed_response['share'].nil?
    end

  end
end

# {
# share: {
# comment_count: 4,
# share_count: 97173
# },
# og_object: {
# engagement: {
# count: 97384,
# social_sentence: "97K people like this."
# },
# title: "Guardians of the Galaxy (2014)",
# id: "10150298925420108"
# },
# id: "http://www.imdb.com/title/tt2015381/"
# }
