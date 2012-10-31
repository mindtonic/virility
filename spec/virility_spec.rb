require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Virility" do

  #
  # Factory
  #

  describe "factory" do
    context "valid strategies" do
      Virility::TESTING_STRATEGIES.each do |strategy, object|
        it "#{strategy} should create and return a #{object} object" do
          Virility.factory(strategy, "http://creativeallies.com").should be_a_kind_of object
        end
      end
    end

    context "invalid strategies" do
      Virility::FAKE_TESTING_STRATEGIES.each do |strategy|
        it "#{strategy} should raise an error" do
          lambda { Virility.factory(strategy, "http://creativeallies.com") }.should raise_error
        end
      end
    end
  end

  #
  # Public API
  #

  describe "Public API testing" do
    before(:each) do
      @url = "http://creativeallies.com"
      Virility::Delicious.stub(:get).and_return(double("HTTParty::Response", :parsed_response => {"url"=>"http://creativeallies.com/", "total_posts"=>50, "top_tags"=>{"graphic"=>1, "art"=>1, "contest"=>1, "photography"=>1, "creativity"=>1, "design"=>1, "online"=>1, "music"=>1, "contests"=>1, "freelance"=>1}, "hash"=>"f9468b2d2842d4a9685af46e1b8e9349", "title"=>"Creative Allies | Create Art For Rockstars"}))
      Virility::Facebook.stub(:get).and_return(double("HTTParty::Response", :parsed_response => {"fql_query_response"=>{"list"=>"true", "link_stat"=>{"like_count"=>"977662", "click_count"=>"265614", "share_count"=>"3020040", "comment_count"=>"1118601", "commentsbox_count"=>"0", "total_count"=>"5116303"}}}))
      Virility::Pinterest.stub(:get).and_return(double("HTTParty::Response", :parsed_response => {"count"=>1, "url"=>"http://creativeallies.com"}))
      Virility::PlusOne.stub(:get).and_return(double("HTTParty::Response", :parsed_response => {"shares"=>"8"}))
      Virility::StumbleUpon.stub(:get).and_return(double("HTTParty::Response", :parsed_response => {"url"=>"http://creativeallies.com/", "in_index"=>true, "publicid"=>"2UhTwK", "views"=>4731, "title"=>"Creative Allies | Create Art For Rockstars | Upload For A Chance To Win", "thumbnail"=>"http://cdn.stumble-upon.com/mthumb/388/49348388.jpg", "thumbnail_b"=>"http://cdn.stumble-upon.com/images/nobthumb.png", "submit_link"=>"http://www.stumbleupon.com/submit/?url=http://creativeallies.com/", "badge_link"=>"http://www.stumbleupon.com/badge/?url=http://creativeallies.com/", "info_link"=>"http://www.stumbleupon.com/url/creativeallies.com/"}))
      Virility::Twitter.stub(:get).and_return(double("HTTParty::Response", :parsed_response => {"count"=>121, "url"=>"http://creativeallies.com/"}))
    end
    
    it "Virility.counts should return a hash of counts" do
      Virility.counts(@url).should == {:delicious=>50, :facebook=>5116303, :pinterest=>1, :plus_one=>8, :stumble_upon=>4731, :twitter=>121}
    end
    
    it "Virility.total should return the total count" do
      Virility.total(@url).should == 5121214
    end
    
    it "Virility.poll should return all of the hashed responses" do
      Virility.poll(@url).should == {:delicious=>{"url"=>"http://creativeallies.com/", "total_posts"=>50, "top_tags"=>{"graphic"=>1, "art"=>1, "contest"=>1, "photography"=>1, "creativity"=>1, "design"=>1, "online"=>1, "music"=>1, "contests"=>1, "freelance"=>1}, "hash"=>"f9468b2d2842d4a9685af46e1b8e9349", "title"=>"Creative Allies | Create Art For Rockstars"}, :facebook=>{"like_count"=>"977662", "click_count"=>"265614", "share_count"=>"3020040", "comment_count"=>"1118601", "commentsbox_count"=>"0", "total_count"=>"5116303"}, :pinterest=>{"count"=>1, "url"=>"http://creativeallies.com"}, :plus_one=>{"shares"=>"8"}, :stumble_upon=>{"url"=>"http://creativeallies.com/", "in_index"=>true, "publicid"=>"2UhTwK", "views"=>4731, "title"=>"Creative Allies | Create Art For Rockstars | Upload For A Chance To Win", "thumbnail"=>"http://cdn.stumble-upon.com/mthumb/388/49348388.jpg", "thumbnail_b"=>"http://cdn.stumble-upon.com/images/nobthumb.png", "submit_link"=>"http://www.stumbleupon.com/submit/?url=http://creativeallies.com/", "badge_link"=>"http://www.stumbleupon.com/badge/?url=http://creativeallies.com/", "info_link"=>"http://www.stumbleupon.com/url/creativeallies.com/"}, :twitter=>{"count"=>121, "url"=>"http://creativeallies.com/"}}
    end
    
    it "Virility.url should return a Virility::Excitation object" do
      Virility.url(@url).should be_a_kind_of Virility::Excitation
    end
  end

  #
  # Error Proofing
  #
  
  describe "Error Proofing" do
    it "should not raise an error with a bad URL" do
      lambda { Virility.counts("http://this.is.a.crap.url") }.should_not raise_error
    end
    
    it "should return 0 for all strategy counts" do
      @virility = Virility.url("http://this.is.a.crap.url")
      @virility.total.should == 0
      @virility.counts.should == {:delicious=>0, :facebook=>0, :pinterest=>0, :plus_one=>0, :stumble_upon=>0, :twitter=>0}
    end
  end
end
