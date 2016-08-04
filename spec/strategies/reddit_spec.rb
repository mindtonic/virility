require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "Virility::Reddit" do
  before(:each) do
    @url = "http://creativeallies.com"
  end

  describe "poll" do
    context "when there is not a valid result" do
      before(:each) do
        response = double("HTTParty::Response", :parsed_response => {"fake_return_value" => "OICU812"})
        allow(Virility::Reddit).to receive(:get) { response }
        @virility = Virility::Reddit.new(@url)
      end
      it_should_behave_like "no context results"
    end

    context "when there is no result" do
      before(:each) do
        response = double("HTTParty::Response")
        allow(Virility::Reddit).to receive(:get) { response }
        @virility = Virility::Reddit.new(@url)
      end
      it_should_behave_like "no context results"
    end

    context "when there is a result but no specific hash value" do
      before(:each) do
        response = double("HTTParty::Response", :parsed_response => {})
        allow(Virility::Reddit).to receive(:get) { response }
        @virility = Virility::Reddit.new(@url)
      end
      it_should_behave_like "no context results"
    end

    context "when there is a result but parsed_response is weird" do
      before(:each) do
        response = double("HTTParty::Response", :parsed_response => Object.new)
        allow(Virility::Reddit).to receive(:get) { response }
        @virility = Virility::Reddit.new(@url)
      end

      it_should_behave_like "no context results"
    end

    context "when there is a valid result" do
      before(:each) do
        response = double("HTTParty::Response", :parsed_response =>
          { "kind" => "Listing",
            "data" => {
              "modhash" => "",
              "children" =>
            [{ "kind" => "t3", "data" => { "score" => 35 } }]
          }
        }
        )
        allow(Virility::Reddit).to receive(:get) { response }
        @virility = Virility::Reddit.new(@url)
      end

      it "should not raise an error" do
        expect{ @virility.poll }.not_to raise_error
      end

      it "should return 35 for the count" do
        expect(@virility.count).to eq(35)
      end
    end
  end
end
