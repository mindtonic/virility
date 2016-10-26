require 'cgi'
require 'httparty'
require 'multi_json'

require 'virility/version'
require 'virility/supporter'
require 'virility/excitation'
require 'virility/strategy'
require 'virility/exceptions'

Dir["#{File.dirname(__FILE__)}/virility/strategies/**/*.rb"].each { |f| require f }

module Virility

  #
  # Public API
  #

  def self.counts(url, strategies: [], proxy: {})
    Virility::Excitation.new(url, strategies, proxy: proxy).counts
  end

  def self.total(url, strategies: [], proxy: {})
    Virility::Excitation.new(url, strategies, proxy: proxy).total
  end

  def self.poll(url, strategies = [], proxy: {})
    Virility::Excitation.new(url, strategies, proxy: proxy).poll
  end

  def self.url(url, strategies: [], proxy: {})
    virility = Virility::Excitation.new(url, strategies, proxy: proxy)
    virility.poll
    virility
  end

  #
  # Factory
  #

  def self.factory(strategy, url, proxy = {})
    Virility::Excitation.new(url).send(strategy, proxy)
  end
end
