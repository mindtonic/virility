require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Virility" do

  #
  # Factory
  #

  describe "factory" do
    context "valid strategies" do
      Virility::TESTING_STRATEGIES.each do |strategy, object|
        it "#{strategy} should create and return a #{object} object" do
          expect(Virility.factory(strategy, "http://creativeallies.com")).to be_a_kind_of(object)
        end
      end
    end

    context "invalid strategies" do
      Virility::FAKE_TESTING_STRATEGIES.each do |strategy|
        it "#{strategy} should raise an error" do
          expect{ Virility.factory(strategy, "http://creativeallies.com") }.to raise_error(Virility::UnknownStrategy, "#{strategy} Is Not A Known Strategy")
        end
      end
    end
  end

  #
  # Public API
  #

  describe "Public API testing" do
    before(:each) do
      @url = "http://creativeallies.com"
      allow(Virility::Facebook).to receive(:get) { double("HTTParty::Response", :parsed_response => { 'share' => { 'comment_count' => '4', 'share_count' => '97173'}, 'og_object' => { 'engagement' => { 'count' => '97384', 'social_sentence' => "97K people like this."}, title: "Guardians of the Galaxy (2014)", id: "10150298925420108"}, id: "http://www.imdb.com/title/tt2015381/"}) }
      allow(Virility::Pinterest).to receive(:get) { double("HTTParty::Response", :parsed_response => {"count"=>1, "url"=>"http://creativeallies.com"}) }
      allow(Virility::PlusOne).to receive(:get) { double("HTTParty::Response", :parsed_response => {"shares"=>"8"}) }
      allow(Virility::StumbleUpon).to receive(:get) { double("HTTParty::Response", :parsed_response => {"url"=>"http://creativeallies.com/", "in_index"=>true, "publicid"=>"2UhTwK", "views"=>4731, "title"=>"Creative Allies | Create Art For Rockstars | Upload For A Chance To Win", "thumbnail"=>"http://cdn.stumble-upon.com/mthumb/388/49348388.jpg", "thumbnail_b"=>"http://cdn.stumble-upon.com/images/nobthumb.png", "submit_link"=>"http://www.stumbleupon.com/submit/?url=http://creativeallies.com/", "badge_link"=>"http://www.stumbleupon.com/badge/?url=http://creativeallies.com/", "info_link"=>"http://www.stumbleupon.com/url/creativeallies.com/"}) }
      allow(Virility::Linkedin).to receive(:get) { double("HTTParty::Response", :parsed_response => { "count":17, "fCnt":"17", "fCntPlusOne":"18", "url":"http:\/\/creativeallies.com" }) }
      allow(Virility::Reddit).to receive(:get) { double("HTTParty::Response", :parsed_response => { "data" => { "children" => [{ "data" => { "domain" => "apple.com", "banned_by" => nil, "media_embed" => {}, "num_reports" => nil, "score" => 1}}, { "data" => { "domain" => "apple.com", "banned_by" => nil, "media_embed" => {}, "num_reports" => nil, "score" => 34 }}]}})}
    end

    it "Virility.counts should return a hash of counts" do
      expect(Virility.counts(@url)).to eq({:facebook=>97384, :linkedin => 17, :pinterest=>1, :plus_one=>8, reddit:35, :stumble_upon=>4731})
    end

    it "Virility.total should return the total count" do
      expect(Virility.total(@url)).to eq(102176)
    end

    it "Virility.poll should return all of the hashed responses" do
      expect(Virility.poll(@url)).to eq({
        :facebook=>{"comment_count"=>"4", "share_count"=>"97173", "engagement_count"=>"97384", "social_sentence"=>"97K people like this."},
        :linkedin=>{ "count":17, "fCnt":"17", "fCntPlusOne":"18", "url":"http:\/\/creativeallies.com" },
        :pinterest=>{"count"=>1, "url"=>"http://creativeallies.com"},
        :plus_one=>{"shares"=>"8"},
        :stumble_upon=>{"url"=>"http://creativeallies.com/", "in_index"=>true, "publicid"=>"2UhTwK", "views"=>4731, "title"=>"Creative Allies | Create Art For Rockstars | Upload For A Chance To Win", "thumbnail"=>"http://cdn.stumble-upon.com/mthumb/388/49348388.jpg", "thumbnail_b"=>"http://cdn.stumble-upon.com/images/nobthumb.png", "submit_link"=>"http://www.stumbleupon.com/submit/?url=http://creativeallies.com/", "badge_link"=>"http://www.stumbleupon.com/badge/?url=http://creativeallies.com/", "info_link"=>"http://www.stumbleupon.com/url/creativeallies.com/"},
        :reddit=>{"score"=>35 }
      })
    end
    it "Virility.poll should return all of the hashed responses with filtered strategies only" do
      expect(Virility.poll(@url,[:facebook,:linkedin,:pinterest,:plus_one,:stumble_upon])).to eq({
        :facebook=>{"share_count"=>"97173", "engagement_count"=>'97384', "comment_count"=>"4", 'social_sentence' => "97K people like this."},
        :linkedin=>{ "count":17, "fCnt":"17", "fCntPlusOne":"18", "url":"http:\/\/creativeallies.com" },
        :pinterest=>{"count"=>1, "url"=>"http://creativeallies.com"},
        :plus_one=>{"shares"=>"8"},
        :stumble_upon=>{"url"=>"http://creativeallies.com/", "in_index"=>true, "publicid"=>"2UhTwK", "views"=>4731, "title"=>"Creative Allies | Create Art For Rockstars | Upload For A Chance To Win", "thumbnail"=>"http://cdn.stumble-upon.com/mthumb/388/49348388.jpg", "thumbnail_b"=>"http://cdn.stumble-upon.com/images/nobthumb.png", "submit_link"=>"http://www.stumbleupon.com/submit/?url=http://creativeallies.com/", "badge_link"=>"http://www.stumbleupon.com/badge/?url=http://creativeallies.com/", "info_link"=>"http://www.stumbleupon.com/url/creativeallies.com/"}
      })
    end
    it "Virility.poll should return all of the hashed responses with filtered strategies only" do
      expect(Virility.poll(@url,[:facebook,:linkedin,:pinterest,:plus_one,:stumble_upon])).to eq({
        :facebook=>{"share_count"=>"97173", "engagement_count"=>'97384', "comment_count"=>"4", 'social_sentence' => "97K people like this."},
        :linkedin=>{ "count":17, "fCnt":"17", "fCntPlusOne":"18", "url":"http:\/\/creativeallies.com" },
        :pinterest=>{"count"=>1, "url"=>"http://creativeallies.com"},
        :plus_one=>{"shares"=>"8"},
        :stumble_upon=>{"url"=>"http://creativeallies.com/", "in_index"=>true, "publicid"=>"2UhTwK", "views"=>4731, "title"=>"Creative Allies | Create Art For Rockstars | Upload For A Chance To Win", "thumbnail"=>"http://cdn.stumble-upon.com/mthumb/388/49348388.jpg", "thumbnail_b"=>"http://cdn.stumble-upon.com/images/nobthumb.png", "submit_link"=>"http://www.stumbleupon.com/submit/?url=http://creativeallies.com/", "badge_link"=>"http://www.stumbleupon.com/badge/?url=http://creativeallies.com/", "info_link"=>"http://www.stumbleupon.com/url/creativeallies.com/"}
      })
    end

    it "Virility.url should return a Virility::Excitation object" do
      expect(Virility.url(@url)).to be_a_kind_of(Virility::Excitation)
    end
  end

  #
  # Error Proofing
  #

  describe "Error Proofing" do
    it "should not raise an error with a bad URL" do
      expect{ Virility.counts("http://this.is.a.crap.url") }.not_to raise_error
    end

    it "should return 0 for all strategy counts" do
      @virility = Virility.url("http://this.is.a.crap.url")
      expect(@virility.total).to eq(0)
      expect(@virility.counts).to eq({:facebook=>0, :linkedin=>0, :pinterest=>0, :plus_one=>0, :reddit=>0, :stumble_upon=>0 })
    end
  end
end
