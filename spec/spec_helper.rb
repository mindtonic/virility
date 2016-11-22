$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'rspec'
require 'pry'
require 'virility'

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

RSpec.configure do |config|
  config.filter_run :focus => true
  config.run_all_when_everything_filtered = true
  config.mock_with :rspec
end

#
# Constants for Testing
#

module Virility
  TESTING_STRATEGIES = {
    :facebook => Virility::Facebook,
    :pinterest => Virility::Pinterest,
    :plus_one => Virility::PlusOne,
    :stumble_upon => Virility::StumbleUpon,
    :linkedin => Virility::Linkedin,
    :reddit => Virility::Reddit
  }
  FAKE_TESTING_STRATEGIES = [:digg, :instagram, :tumblr]
  FB_RESULTS  = { 'comment_count' => '4', 'share_count' => '97173', 'engagement_count' => '97384', 'social_sentence' => "97K people like this."}
  FAKE_FB_RESULTS = [:face_count, :pages, :friends]
end

#
# Example Groups
#

RSpec.shared_examples "no context results" do
  it "should not raise an error" do
    expect{ @virility.poll }.not_to raise_error
  end

  it "should return 0 for count" do
    expect(@virility.count).to eq(0)
  end
end
