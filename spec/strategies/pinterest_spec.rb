require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "Virility::Pinterest" do
  before(:each) do
    @url = "http://creativeallies.com"
  end

  describe "poll" do
    context "when there is not a valid result" do
      before(:each) do
        response = double("HTTParty::Response", :parsed_response => {"fake_return_value"=> "OICU812"})
        allow(Virility::Pinterest).to receive(:get) { response }
        @virility = Virility::Pinterest.new(@url)
      end

      it_should_behave_like "no context results"
    end

    context "when there is no result" do
      before(:each) do
        response = double("HTTParty::Response")
        allow(Virility::Pinterest).to receive(:get) { response }
        @virility = Virility::Pinterest.new(@url)
      end

      it_should_behave_like "no context results"
    end

    context "when there is a result but no specific hash value" do
      before(:each) do
        response = double("HTTParty::Response", :parsed_response => {})
        allow(Virility::Pinterest).to receive(:get) { response }
        @virility = Virility::Pinterest.new(@url)
      end

      it_should_behave_like "no context results"
    end

    context "when there is a result but parsed_response is weird" do
      before(:each) do
        response = double("HTTParty::Response", :parsed_response => Object.new)
        allow(Virility::Pinterest).to receive(:get) { response }
        @virility = Virility::Pinterest.new(@url)
      end

      it_should_behave_like "no context results"
    end

    context "when there is a valid result" do
      before(:each) do
        response = double("HTTParty::Response", :parsed_response => {"count"=>1, "url"=>"http://creativeallies.com"})
        allow(Virility::Pinterest).to receive(:get) { response }
        @virility = Virility::Pinterest.new(@url)
      end

      it "should not raise an error" do
        expect{ @virility.poll }.not_to raise_error
      end

      it "should return 1 for the count" do
        expect(@virility.count).to eq(1)
      end
    end
  end

end