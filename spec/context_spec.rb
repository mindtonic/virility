require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Context" do
	before(:each) do
		@url = "http://creativeallies.com"
	end
	
	#
	# Initialization
	#

	context "initialization" do
		it "should raise an error if a URL is not set" do
			lambda {Virility::Context.new}.should raise_error
		end

		it "should set the url" do
			Virility::Excitation.new(@url).url.should == @url
		end
	end
	
	#
	# Interface
	#

	context "interface" do
		it "should raise an error on poll" do
			lambda { Virility::Context.new(@url).poll }.should raise_error
		end
	end
end
