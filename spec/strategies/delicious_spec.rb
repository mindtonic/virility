require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "Virility::Delicious" do
  before(:each) do
    @url = "http://creativeallies.com"
  end
  
  describe "poll" do
    context "when there is not a valid result" do
      before(:each) do
        response = double("HTTParty::Response", :parsed_response => {"fake_return_value"=> "OICU812"})
        Virility::Delicious.stub(:get).and_return(response)
        @virility = Virility::Delicious.new(@url)
      end

      it_should_behave_like "no context results"
    end

    context "when there is no result" do
      before(:each) do
        response = double("HTTParty::Response")
        Virility::Delicious.stub(:get).and_return(response)
        @virility = Virility::Delicious.new(@url)
      end

      it_should_behave_like "no context results"
    end

    context "when there is a result but no specific hash value" do
      before(:each) do
        response = double("HTTParty::Response", :parsed_response => {})
        Virility::Delicious.stub(:get).and_return(response)
        @virility = Virility::Delicious.new(@url)
      end

      it_should_behave_like "no context results"
    end

    context "when there is a result but parsed_response is weird" do
      before(:each) do
        response = double("HTTParty::Response", :parsed_response => Object.new)
        Virility::Delicious.stub(:get).and_return(response)
        @virility = Virility::Delicious.new(@url)
      end

      it_should_behave_like "no context results"
    end

    context "when there is a valid result" do
      before(:each) do
        response = double("HTTParty::Response", :parsed_response => {"url"=>"http://creativeallies.com/", "total_posts"=>50, "top_tags"=>{"graphic"=>1, "art"=>1, "contest"=>1, "photography"=>1, "creativity"=>1, "design"=>1, "online"=>1, "music"=>1, "contests"=>1, "freelance"=>1}, "hash"=>"f9468b2d2842d4a9685af46e1b8e9349", "title"=>"Creative Allies | Create Art For Rockstars"})
        Virility::Delicious.stub(:get).and_return(response)
        @virility = Virility::Delicious.new(@url)
      end

      it "should not raise an error" do
        lambda { @virility.poll }.should_not raise_error
      end

      it "should return 50 for the count" do
        @virility.count.should == 50
      end
    end
  end

end