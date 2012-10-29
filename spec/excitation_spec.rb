require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Excitation" do
	before(:each) do
		@url = "http://www.dzone.com/snippets/uri-encoding-ruby"
	end
	
	#
	# Initialization
	#

	context "initialization" do
		it "should raise an error if a URL is not set" do
			lambda {Virility::Excitation.new}.should raise_error
		end

		it "should automatically encode the url" do
			Virility::Excitation.new(@url).attributes[:url].should == "http%3A%2F%2Fwww.dzone.com%2Fsnippets%2Furi-encoding-ruby"
		end
	end
	
	#
	# Get Virility
	#

# 	context "get_virility" do
# 		it "should not raise an error" do
# 			lambda {Virility::Excitation.new(@url).get_virility}.should_not raise_error
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
			v.encode(@url).should == "http%3A%2F%2Fwww.dzone.com%2Fsnippets%2Furi-encoding-ruby"
		end
	end
	
	#
	# URL
	#

	context "url" do
		it "should return the unencoded url" do
			Virility::Excitation.new(@url).url.should == @url
		end
	end
	
	#
	# Escaped URL
	#

	context "escaped_url" do
		it "should return the encoded url" do
			Virility::Excitation.new(@url).escaped_url.should == "http%3A%2F%2Fwww.dzone.com%2Fsnippets%2Furi-encoding-ruby"
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
 
end
