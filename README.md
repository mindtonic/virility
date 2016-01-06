# Virility

Virility calls upon the API's of many popular social services such as Facebook, Twitter and Pinterest to collect the number of likes, tweets, pins etc. of a particular URL.  Written with a modular construction, Virility makes it easy to drop new data collection strategies into the framework so that you can collect all of your statistics in one easy location.

View a demo online: http://virility.herokuapp.com/

## Installation

Add this line to your application's Gemfile:

    gem 'virility'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install virility

## Basic Usage

If all you need is the raw shares numbers for a URL, Virility has some very simple methods you can use right out of the box:

    Virility.poll("http://rubygems.org")   # => Returns a hash with the collected results from all of the social network strategies
    Virility.counts("http://rubygems.org") # => {:delicious=>0, :facebook=>72, :pinterest=>0, :plus_one=>138, :stumble_upon=>1488, :twitter=>2322}
    Virility.total("http://rubygems.org")  # => 4020
    Virility.url("http://rubygems.org")    # => Returns a Virility::Excitation object that you can manipulate

## More Granular Usage

The Virility::Excitation object does the heavy lifting of collecting the data from all of the available strategies.

    virility = Virility::Excitation.new("http://rubygems.org")
    virility.poll   # returns a hash with the collected output of all data sources
    virility.counts # returns a hash of just the virility counts => {:delicious=>943, :facebook=>72, :pinterest=>0, :plusone=>137, :stumbleupon=>1488, :twitter=>2319}
    virility.total  # returns the sum of all virility counts

## Individual Strategies

Currently there is support for the following social resources:
* Facebook
* Twitter
* Pinterest
* Google Plus One
* Stumble Upon

Each social resource is implemented as a Virility::Strategy and contains at least three methods: poll, results and count.  __poll__ does the work of querying the API to get the data and returns the same hash as the results method, __results__ returns the hashed values that were provided by the social network and __count__ pulls out the individual number of shares for that social network.

#### Strategy Initialization

There are several ways you can access the object for an individual strategy.

The Virility object has a __factory__ method that will return the strategy object:

    tweets = Virility.factory(:twitter, "http://rubygems.org") # => returns a Virility::Twitter object with the rubygems url

You can also instate the Virility::Twitter object directly:

    tweets = Virility::Twitter.new("http://rubygems.org")

#### Individual Usage Example

Let's say you only need to get the number of tweets for a URL, you could use the Virility::Twitter class by itself:

    tweets = Virility::Twitter.new("http://rubygems.org")
    tweets.poll    # returns a hash with the collected output from Twitter => {"url"=>"http://rubygems.org/", "count"=>2319}
    tweets.results # returns a hash with the collected output from Twitter => {"url"=>"http://rubygems.org/", "count"=>2319}
    tweets.count   # returns the number of tweets for that URL => 2319

## Facebook Usage

    fb = Virility::Facebook.new("http://rubygems.org")
    fb.poll  # returns a hash with the collected output from Facebook
    fb.count # returns the total_count for that URL

The Facebook strategy leverages the FQL query against the link_stat table. Because of this, the following data fields are available:
* like_count
* click_count
* share_count
* comment_count
* commentsbox_count
* total_count (used as the default count for all Facebook activity)

## Dynamic Finders

#### Virility::Excitation

If you have a Virility::Excitation object, there are dynamic finders that will return the individual Virility::Strategy object for a social network. Simply call the name of the strategy against the Virility::Excitation object and that strategy will be returned:

    virility     = Virility::Excitation.new("http://rubygems.org")
    facebook     = virility.facebook
    twitter      = virility.twitter
    delicious    = virility.delicious
    pinterest    = virility.pinterest
    plus_one     = virility.plus_one
    stumble_upon = virility.stumble_upon

#### Virility::Strategy

If you have a Strategy object, any of the attributes that are commonly returned through the API call will be available as a dynamic finder.  This is particularly useful with the Facebook strategy:

    fb = Virility::Facebook.new("http://rubygems.org/")
    fb.like_count    # => 12
    fb.share_count   # => 40
    fb.comment_count # => 20
    fb.total_count   # => 72

#### Combined Finders

Leveraging both sets of dynamic finders allows you to build an Excitation object and get all the way through to an attribute for a specific strategy:

    Virility.url("http://google.com/").facebook.like_count # => 979662
    Virility.url("http://google.com/").stumble_upon.info_link # => "http://www.stumbleupon.com/url/www.google.com/"

## Important Notes

URL's are very specific in the context of a social media.  For example, http://rubygems.org will return different results than http://rubygems.org/ with a trailing slash.  Also, http vs https will give you different numbers. This actually has a lot to do with why we created this gem.  When testing be sure to investigate all of the URL variations in order to get the most complete picture of your data.

#### Case Study

Compare the total count results for http://ruby-lang.org/en. One has the trailing slash and one does not.

    Virility::Excitation.new("http://www.ruby-lang.org/en").total # => 247695
    Virility::Excitation.new("http://www.ruby-lang.org/en/").total # => 253190

On this particular day, there was a 5,495 count difference between the two values. Inspecting the actual results shows you which of the social networks takes the varying forms of the urls into account:

    Virility::Excitation.new("http://www.ruby-lang.org/en").counts
    # => {:delicious=>37, :facebook=>3, :pinterest=>0, :plusone=>20, :stumbleupon=>246937, :twitter=>698}

    Virility::Excitation.new("http://www.ruby-lang.org/en/").counts
    # => {:delicious=>4314, :facebook=>813, :pinterest=>22, :plusone=>406, :stumbleupon=>246937, :twitter=>698}

Stumbleupon and Twitter are consistent while Facebook, Pinterest and Google Plus One return different results. Depending on your needs, you could craft an algorithm that takes all of this into account and attempts to deliver an accurate number by combining the data sets that are different and trusting the ones that are the same.

Based on this logic, it is possible to consider that the true total share count is closer to _253,250_. Not only is this an opinionated number, it's accuracy is questionable based on assumptions, however if you are just trying to get a ballpark feeling of the virility of your content, this number should suffice.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Copyright

Copyright (c) 2012 Jay Sanders. See LICENSE.txt for
further details.
