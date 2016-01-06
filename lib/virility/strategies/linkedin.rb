module Virility
  class Linkedin < Strategy

    parser(
      Proc.new do |body, format|
        MultiJson.decode(body.scan(/(\{.+\})/).flatten.first)
      end
    )

    def census
      self.class.get("http://www.linkedin.com/countserv/count/share?url=#{@original_url}&format=json")
    end

    def count
      results[:count] || 0
    end

  end
end