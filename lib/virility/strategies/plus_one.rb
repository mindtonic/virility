# http://stackoverflow.com/questions/7403553/how-do-i-get-the-counter-of-a-google-plus-1-button
module Virility
  class PlusOne < Strategy
  
    parser(
      Proc.new do |body, format|
        {'shares' => body.scan(/c: (\d+)/).flatten.first}
      end
    )
  
    def census
      self.class.get("https://plusone.google.com/_/+1/fastbutton?url=#{@url}")
    end
    
    def count
      results["shares"].to_i || 0
    end
  
  end
end