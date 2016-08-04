require 'cgi'
require 'httparty'
require 'multi_json'

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

  def self.counts(url, strategies = [])
    Virility::Excitation.new(url, strategies).counts
  end

  def self.total(url, strategies = [])
    Virility::Excitation.new(url, strategies).total
  end

  def self.poll(url, strategies = [])
    Virility::Excitation.new(url, strategies).poll
  end

  def self.url(url, strategies = [])
    virility = Virility::Excitation.new(url, strategies)
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
