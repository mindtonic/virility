require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "Virility::Pinterest" do
	before(:each) do
		@url = "http://creativeallies.com"
	end
	
	describe "poll" do
		context "when there is not a valid result" do
			before(:each) do
				response = double("HTTParty::Response", :parsed_response => {"fake_return_value"=> "OICU812"})
				Virility::Pinterest.stub(:get).and_return(response)
				@virility = Virility::Pinterest.new(@url)
			end

			it_should_behave_like "no context results"
		end

		context "when there is no result" do
			before(:each) do
				response = double("HTTParty::Response")
				Virility::Pinterest.stub(:get).and_return(response)
				@virility = Virility::Pinterest.new(@url)
			end

			it_should_behave_like "no context results"
		end

		context "when there is a result but no specific hash value" do
			before(:each) do
				response = double("HTTParty::Response", :parsed_response => {})
				Virility::Pinterest.stub(:get).and_return(response)
				@virility = Virility::Pinterest.new(@url)
			end

			it_should_behave_like "no context results"
		end

		context "when there is a result but parsed_response is weird" do
			before(:each) do
				response = double("HTTParty::Response", :parsed_response => Object.new)
				Virility::Pinterest.stub(:get).and_return(response)
				@virility = Virility::Pinterest.new(@url)
			end

			it_should_behave_like "no context results"
		end

		context "when there is a valid result" do
			before(:each) do
				response = double("HTTParty::Response", :parsed_response => {"count"=>1, "url"=>"http://creativeallies.com"})
				Virility::Pinterest.stub(:get).and_return(response)
				@virility = Virility::Pinterest.new(@url)
			end

			it "should not raise an error" do
				lambda { @virility.poll }.should_not raise_error
			end

			it "should return 1 for the count" do
				@virility.count.should == 1
			end
		end
	end

end