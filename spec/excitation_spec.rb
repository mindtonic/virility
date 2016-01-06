require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Excitation" do
  before(:each) do
    @url = "http://creativeallies.com"
  end

  #
  # Initialization
  #

  context "initialization" do
    it "should raise an error if a URL is not set" do
      expect{Virility::Excitation.new}.to raise_error(ArgumentError, "wrong number of arguments (0 for 1)")
    end
  end

  #
  # Get Virility
  #

  context "poll" do
    it "should not raise an error" do
      expect{Virility::Excitation.new(@url).poll}.not_to raise_error
    end
  end

  #
  # Collect Strategies
  #

  context "collect_strategies" do
    it "should assign a hash to the strategies variable" do
      expect(Virility::Excitation.new(@url).strategies).to be_a_kind_of Hash
    end

    it "strategies should be inherited from the Strategy" do
      expect(Virility::Excitation.new(@url).strategies.first.last).to be_a_kind_of Virility::Strategy
    end

    it "should load all of the strategies" do
      expect(Virility::Excitation.new(@url).strategies.count).to eq(Dir[File.join('lib', 'virility', 'strategies', '**', '*')].count { |file| File.file?(file) })
    end
  end

  #
  # Encode
  #

  context "encode" do
    it "should encode the url" do
      v = Virility::Excitation.new(@url)
      expect(v.encode(@url)).to eq("http%3A%2F%2Fcreativeallies.com")
    end
  end

  #
  # Symbolize For Key
  #

  context "symbolize_for_key" do
    it "should return a symbol with the name of the class" do
      expect(Virility::Excitation.new(@url).symbolize_for_key(Virility::Excitation.new(@url))).to eq(:excitation)
    end
  end

  #
  # Dynamic Methods
  #

  describe "dynamic methods" do
    context "overall testing" do
      Virility::TESTING_STRATEGIES.each do |method, klass|
        it "should return a #{klass} object when the method #{method} is called" do
          expect(Virility::Excitation.new(@url).send(method)).to be_a_kind_of(klass)
        end
      end

      Virility::FAKE_TESTING_STRATEGIES.each do |method|
        it "should raise an error if the strategy (#{method}) does not exist" do
          expect{ Virility::Excitation.new(@url).send(method) }.to raise_error(Virility::UnknownStrategy, "#{method} Is Not A Known Strategy")
        end
      end
    end

    context "strategy_exists?" do
      Virility::TESTING_STRATEGIES.keys.each do |strategy|
        it "should return true for #{strategy}" do
          expect(Virility::Excitation.new(@url).strategy_exists?(strategy)).to be(true)
        end
      end

      Virility::FAKE_TESTING_STRATEGIES.each do |strategy|
        it "should return false for #{strategy}" do
          expect(Virility::Excitation.new(@url).strategy_exists?(strategy)).to be(false)
        end
      end
    end

    context "get_strategy" do
      Virility::TESTING_STRATEGIES.each do |method, klass|
        it "should return a #{klass} object when get_strategy is called with #{method}" do
          expect(Virility::Excitation.new(@url).get_strategy(method)).to be_a_kind_of(klass)
        end
      end

      Virility::FAKE_TESTING_STRATEGIES.each do |method|
        it "should raise an error if the strategy (#{method}) does not exist" do
          expect(lambda { Virility::Excitation.new(@url).get_strategy(method) }).to raise_error(Virility::UnknownStrategy, "#{method} Is Not A Known Strategy")
        end
      end
    end
  end
end