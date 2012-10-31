module Virility
	class Context
  	include HTTParty
		include Virility::Supporter

		attr_accessor :url, :response, :results

		def initialize url
			@url = encode url
			@results = {}
		end
		
		#
		# Abstract Methods - Delete eventually
		#

		def census
			raise "Abstract Method census called on #{self.class} - Please define this method"
		end

		def count
			raise "Abstract Method count called on #{self.class} - Please define this method"
		end
		
		#
		# Poll
		#
		
		def poll
			call_strategy
			collect_results
		end
		
		#
		# Call Strategy
		#
		
		def call_strategy
			@response = census
		end

		#
		# Results
		#
		
		def collect_results
			if respond_to?(:outcome)
				@results = valid_response_test ? outcome : {}
			else
				@results = valid_response_test ? @response.parsed_response : {}
			end
		end

		def results
			if @results.empty?
				begin
					poll
				rescue => e
					puts "[virility#poll] #{self.class.to_s} => #{e}"
				end
			end
			@results
		end

		#
		# Dynamic Methods
		#

		def get_result key
			if result_exists?(key)
				results[key.to_s]
			else
				0
			end
		end

		def result_exists? key
			!results[key.to_s].nil?
		end

		def method_missing(name, *args, &block)
			if result_exists?(name)
				get_result(name)
			else
				0
			end
		end

		#
		# Parsed Response Test - Overwrite if needed
		#

		def valid_response_test
			@response.respond_to?(:parsed_response) and @response.parsed_response.is_a?(Hash)
		end

	end
end