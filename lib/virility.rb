require 'cgi'
require 'httparty'

require 'virility/version'
require 'virility/supporter'
require 'virility/excitation'
require 'virility/strategy'
require 'virility/exceptions'

Dir["#{File.dirname(__FILE__)}/virility/strategies/**/*.rb"].each {|f| require f}

module Virility

  #
  # Public API
  #

  def self.counts(url)
    Virility::Excitation.new(url).counts
  end

  def self.total(url)
    Virility::Excitation.new(url).total
  end

  def self.poll(url)
    Virility::Excitation.new(url).poll
  end

  def self.url(url)
    virility = Virility::Excitation.new(url)
    virility.poll
    virility
  end

  #
  # Factory
  #

  def self.factory(strategy, url)
    Virility::Excitation.new(url).send(strategy)
  end
end
