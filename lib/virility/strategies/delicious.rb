module Virility
  class Delicious < Strategy

    parser(
      Proc.new do |body, format|
        MultiJson.decode(body.scan(/(\{.+\})/).flatten.first)
      end
    )

    def census
      self.class.get("http://feeds.delicious.com/v2/json/urlinfo/data?url=#{@url}")
    end

    def count
      results["total_posts"] || 0
    end

  end
end