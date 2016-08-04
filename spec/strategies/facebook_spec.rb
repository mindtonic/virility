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
      before(:each) do
        response = double("HTTParty::Response", :parsed_response => {"links_getStats_response"=>{"list"=>"true", "link_stat"=>{"like_count"=>"977662", "click_count"=>"265614", "share_count"=>"3020040", "comment_count"=>"1118601", "commentsbox_count"=>"0", "total_count"=>"5116303"}}})
        allow(Virility::Facebook).to receive(:get) { response }
        @virility = Virility::Facebook.new(@url)
      end

      it "should not raise an error" do
        expect{ @virility.poll }.not_to raise_error
      end

      {"like_count"=>"977662", "click_count"=>"265614", "share_count"=>"3020040", "comment_count"=>"1118601", "commentsbox_count"=>"0", "total_count"=>"5116303"}.each do |key, value|
        it "should return #{value} for #{key}" do
          expect(@virility.send(key.to_sym)).to eq(value)
        end
      end
    end

    context "when there is a valid result, but not all fields are present" do
      before(:each) do
        response = double("HTTParty::Response", :parsed_response => {"links_getStats_response"=>{"list"=>"true", "link_stat"=>{"like_count"=>"977662", "comment_count"=>"1118601", "commentsbox_count"=>"0", "total_count"=>"5116303"}}})
        allow(Virility::Facebook).to receive(:get) { response }
        @virility = Virility::Facebook.new(@url)
      end

      it "should not raise an error" do
        expect{ @virility.poll }.not_to raise_error
      end

      {"like_count"=>"977662", "click_count"=>0, "share_count"=>0, "comment_count"=>"1118601", "commentsbox_count"=>"0", "total_count"=>"5116303"}.each do |key, value|
        it "should return #{value} for #{key}" do
          expect(@virility.send(key.to_sym)).to eq(value)
        end
      end
    end
  end

end
