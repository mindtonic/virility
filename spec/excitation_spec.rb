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
			lambda {Virility::Excitation.new}.should raise_error
		end
	end

	#
	# Get Virility
	#

# 	context "poll" do
# 		it "should not raise an error" do
# 			lambda {Virility::Excitation.new(@url).poll}.should_not raise_error
# 		end
# 	end

	#
	# Collect Strategies
	#

	context "collect_strategies" do
		it "should assign a hash to the strategies variable" do
			Virility::Excitation.new(@url).strategies.should be_a_kind_of Hash
		end

		it "strategies should be inherited from the Context" do
			Virility::Excitation.new(@url).strategies.first.last.should be_a_kind_of Virility::Context
		end

		it "should load all of the strategies" do
			Virility::Excitation.new(@url).strategies.count.should == Dir[File.join('lib', 'virility', 'strategies', '**', '*')].count { |file| File.file?(file) }
		end
	end

	#
	# Encode
	#

	context "encode" do
		it "should encode the url" do
			v = Virility::Excitation.new(@url)
			v.encode(@url).should == "http%3A%2F%2Fcreativeallies.com"
		end
	end

	#
	# Symbolize For Key
	#

	context "symbolize_for_key" do
		it "should return a symbol with the name of the class" do
			Virility::Excitation.new(@url).symbolize_for_key(Virility::Excitation.new(@url)).should == :excitation
		end
	end

	#
	# Dynamic Methods
	#
	
	TESTING_STRATEGIES = {:facebook => Virility::Facebook, :twitter => Virility::Twitter, :delicious => Virility::Delicious, :pinterest => Virility::Pinterest, :plus_one => Virility::PlusOne, :stumble_upon => Virility::StumbleUpon}
	FAKE_TESTING_STRATEGIES = [:digg, :reddit, :linked_in, :instagram, :tumblr]

	describe "dynamic methods" do
		context "overall testing" do
			TESTING_STRATEGIES.each do |method, klass|
				it "should return a #{klass} object when the method #{method} is called" do
					Virility::Excitation.new(@url).send(method).should be_a_kind_of klass
				end
			end

			FAKE_TESTING_STRATEGIES.each do |method|
				it "should raise an error if the strategy (#{method}) does not exist" do
					lambda { Virility::Excitation.new(@url).send(method) }.should raise_error(Virility::UnknownStrategy, "#{method} Is Not A Known Strategy")
				end
			end
		end

		context "strategy_exists?" do
			TESTING_STRATEGIES.keys.each do |strategy|
				it "should return true for #{strategy}" do
					Virility::Excitation.new(@url).strategy_exists?(strategy).should be true
				end
			end

			FAKE_TESTING_STRATEGIES.each do |strategy|
				it "should return false for #{strategy}" do
					Virility::Excitation.new(@url).strategy_exists?(strategy).should be false
				end
			end
		end

		context "get_strategy" do
			TESTING_STRATEGIES.each do |method, klass|
				it "should return a #{klass} object when get_strategy is called with #{method}" do
					Virility::Excitation.new(@url).get_strategy(method).should be_a_kind_of klass
				end
			end

			FAKE_TESTING_STRATEGIES.each do |method|
				it "should raise an error if the strategy (#{method}) does not exist" do
					lambda { Virility::Excitation.new(@url).get_strategy(method) }.should raise_error(Virility::UnknownStrategy, "#{method} Is Not A Known Strategy")
				end
			end
		end

	end

end