# Virility

Virility calls upon the API's of many popular social services such as Facebook, Twitter and Pinterest to collect the number of likes, tweets, pins etc. of a particular URL.  Written with a modular construction, Virility makes it easy to drop new data collection strategies into the framework so that you can collect all of your statistics in one easy location.

## Installation

Add this line to your application's Gemfile:

    gem 'virility'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install virility

## Usage

    stats = Virility::Excitation.new(the_url_you_want_to_collect_data_for)
    stats.get_virility

Currently there is support for the following social resources:
* Facebook
* Twitter
* Delicious
* Pinterest
* Google Plus One
* Stumble Upon

More detailed information coming soon.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

== Copyright

Copyright (c) 2012 Jay Sanders. See LICENSE.txt for
further details.