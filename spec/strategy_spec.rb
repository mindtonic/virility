require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Strategy" do
  before(:each) do
    @url = "http://creativeallies.com"
  end

  #
  # Initialization
  #

  context "initialization" do
    it "should raise an error if a URL is not set" do
      expect{Virility::Strategy.new}.to raise_error(ArgumentError, "wrong number of arguments (0 for 1)")
    end

    it "should set and encode the url" do
      expect(Virility::Facebook.new(@url).url).to eq("http%3A%2F%2Fcreativeallies.com")
    end
  end

  #
  # Interface
  #

  context "interface" do
    it "should raise an error on poll" do
      expect{ Virility::Strategy.new(@url).poll }.to raise_error(RuntimeError, "Abstract Method census called on Virility::Strategy - Please define this method")
    end

    it "should raise an error on count" do
      expect{ Virility::Strategy.new(@url).count }.to raise_error(RuntimeError, "Abstract Method count called on Virility::Strategy - Please define this method")
    end
  end

  #
  # Dynamic Methods
  #

  describe "dynamic methods" do
    before(:each) do
      @virility = Virility::Facebook.new(@url)
      allow(@virility).to receive(:results) { Virility::FB_RESULTS }
    end

    context "overall testing" do
      Virility::FB_RESULTS.each do |key, value|
        it "should return #{value} when get_result is called with #{key}" do
          expect(@virility.send(key)).to eq(value)
        end
      end

      Virility::FAKE_FB_RESULTS.each do |key|
        it "should_not raise an error if the result (#{key}) does not exist" do
          expect{ @virility.send(key) }.not_to raise_error
        end

        it "should return 0 if the result (#{key}) does not exist" do
          expect(@virility.send(key)).to eq(0)
        end
      end
    end

    context "result_exists?" do
      before(:each) do
        @virility = Virility::Facebook.new(@url)
        allow(@virility).to receive(:results) { Virility::FB_RESULTS }
      end

      Virility::FB_RESULTS.keys.each do |result|
        it "should return true for #{result}" do
          expect(@virility.result_exists?(result)).to eq(true)
        end
      end

      Virility::FAKE_FB_RESULTS.each do |result|
        it "should return false for #{result}" do
          expect(@virility.result_exists?(result)).to eq(false)
        end
      end
    end

    context "get_result" do
      Virility::FB_RESULTS.each do |key, value|
        it "should return #{value} when get_result is called with #{key}" do
          expect(@virility.get_result(key)).to eq(value)
        end
      end

      Virility::FAKE_FB_RESULTS.each do |key|
        it "should_not raise an error if the result (#{key}) does not exist" do
          expect{ @virility.send(key) }.not_to raise_error
        end

        it "should return 0 if the result (#{key}) does not exist" do
          expect(@virility.send(key)).to eq(0)
        end
      end
    end

  end
end
