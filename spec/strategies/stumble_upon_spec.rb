require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "Virility::StumbleUpon" do
	before(:each) do
		@url = "http://creativeallies.com"
	end
	
	describe "poll" do
		context "when there is not a valid result" do
			before(:each) do
				response = double("HTTParty::Response", :parsed_response => {"fake_return_value"=> "OICU812"})
				Virility::StumbleUpon.stub(:get).and_return(response)
				@virility = Virility::StumbleUpon.new(@url)
			end

			it_should_behave_like "no context results"
		end

		context "when there is no result" do
			before(:each) do
				response = double("HTTParty::Response")
				Virility::StumbleUpon.stub(:get).and_return(response)
				@virility = Virility::StumbleUpon.new(@url)
			end

			it_should_behave_like "no context results"
		end

		context "when there is a result but no specific hash value" do
			before(:each) do
				response = double("HTTParty::Response", :parsed_response => {})
				Virility::StumbleUpon.stub(:get).and_return(response)
				@virility = Virility::StumbleUpon.new(@url)
			end

			it_should_behave_like "no context results"
		end

		context "when there is a result but parsed_response is weird" do
			before(:each) do
				response = double("HTTParty::Response", :parsed_response => Object.new)
				Virility::StumbleUpon.stub(:get).and_return(response)
				@virility = Virility::StumbleUpon.new(@url)
			end

			it_should_behave_like "no context results"
		end

		context "when there is a valid result" do
			before(:each) do
				response = double("HTTParty::Response", :parsed_response => {"url"=>"http://creativeallies.com/", "in_index"=>true, "publicid"=>"2UhTwK", "views"=>4731, "title"=>"Creative Allies | Create Art For Rockstars | Upload For A Chance To Win", "thumbnail"=>"http://cdn.stumble-upon.com/mthumb/388/49348388.jpg", "thumbnail_b"=>"http://cdn.stumble-upon.com/images/nobthumb.png", "submit_link"=>"http://www.stumbleupon.com/submit/?url=http://creativeallies.com/", "badge_link"=>"http://www.stumbleupon.com/badge/?url=http://creativeallies.com/", "info_link"=>"http://www.stumbleupon.com/url/creativeallies.com/"})
				Virility::StumbleUpon.stub(:get).and_return(response)
				@virility = Virility::StumbleUpon.new(@url)
			end

			it "should not raise an error" do
				lambda { @virility.poll }.should_not raise_error
			end

			it "should return 4731 for the count" do
				@virility.count.should == 4731
			end
		end
	end

end