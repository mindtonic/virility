require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "Virility::Facebook" do
  before(:each) do
    @url = "http://creativeallies.com"
  end

  RSpec.shared_examples "no facebook results" do
    it "should not raise an error" do
      expect{ @virility.poll }.not_to raise_error
    end

    ["like_count", "click_count", "share_count", "comment_count", "commentsbox_count", "total_count"].each do |attribute|
      it "should return 0 for #{attribute}" do
        expect(@virility.send(attribute.to_sym)).to eq(0)
      end
    end
  end

  describe "poll" do
    context "when there is not a valid result" do
      before(:each) do
        response = double("HTTParty::Response", :parsed_response => {"links_getStats_response"=>{"list"=>"true"}})
        allow(Virility::Facebook).to receive(:get) { response }
        @virility = Virility::Facebook.new(@url)
      end

      it_should_behave_like "no facebook results"
    end

    context "when there is no result" do
      before(:each) do
        response = double("HTTParty::Response")
        allow(Virility::Facebook).to receive(:get) { response }
        @virility = Virility::Facebook.new(@url)
      end

      it_should_behave_like "no facebook results"
    end

    context "when there is a result but no links_getStats_response" do
      before(:each) do
        response = double("HTTParty::Response", :parsed_response => {})
        allow(Virility::Facebook).to receive(:get) { response }
        @virility = Virility::Facebook.new(@url)
      end

      it_should_behave_like "no facebook results"
    end

    context "when there is a result but parsed_response is weird" do
      before(:each) do
        response = double("HTTParty::Response", :parsed_response => Object.new)
        allow(Virility::Facebook).to receive(:get) { response }
        @virility = Virility::Facebook.new(@url)
      end

      it_should_behave_like "no facebook results"
    end

    context "when there is a valid result" do
      let(:fb_response) { { 'share' => { 'comment_count' => '4', 'share_count' => '97173'},
      'og_object' => { 'engagement' => { 'count' => '97384', 'social_sentence' => "97K people like this."},
      title: "Guardians of the Galaxy (2014)", id: "10150298925420108"}, id: "http://www.imdb.com/title/tt2015381/"} }
      before(:each) do
        response = double("HTTParty::Response", parsed_response: fb_response)
        allow(Virility::Facebook).to receive(:get) { response }
        @virility = Virility::Facebook.new(@url)
      end

      it "should not raise an error" do
        expect{ @virility.poll }.not_to raise_error
      end

      {"share_count"=>"97173", "engagement_count"=>'97384', "comment_count"=>"4", 'social_sentence' => "97K people like this."}.each do |key, value|
        it "should return #{value} for #{key}" do
          expect(@virility.send(key.to_sym)).to eq(value)
        end
      end
    end

    context "when there is a valid result, but not all fields are present" do
      let(:fb_response) { { 'share' => { 'comment_count' => '4', 'share_count' => '97173'},
      'og_object' => { 'engagement' => { 'count' => '97384', 'social_sentence' => "97K people like this."},
      title: "Guardians of the Galaxy (2014)", id: "10150298925420108"}, id: "http://www.imdb.com/title/tt2015381/"} }
      before(:each) do
        response = double('HTTParty::Response', parsed_response: fb_response)
        allow(Virility::Facebook).to receive(:get) { response }
        @virility = Virility::Facebook.new(@url)
      end
      it "should not raise an error" do
        expect{ @virility.poll }.not_to raise_error
      end
      {"share_count"=>"97173", "engagement_count"=>'97384', "comment_count"=>"4", 'social_sentence' => "97K people like this."}.each do |key, value|
        it "should return #{value} for #{key}" do
          expect(@virility.send(key.to_sym)).to eq(value)
        end
      end
    end
  end
end
