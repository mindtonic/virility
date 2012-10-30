module Virility
	class Context
  	include HTTParty
		include Virility::Supporter
		
		attr_accessor :url, :response, :results

		def initialize url
			@url = encode url
			@results = {}
		end

		def poll
			raise "Abstract Method poll called on #{self.class} - Please define this method"
		end

		def count
			raise "Abstract Method count called on #{self.class} - Please define this method"
		end
		
		#
		# Results
		#

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
				raise UnknownStrategyValue, "#{key} Is Not A Known Value For #{self.class}"
			end
		end

		def result_exists? key
			!results[key.to_s].nil?
		end

		def method_missing(name, *args, &block)
			if result_exists?(name)
				get_result(name)
			else
				raise UnknownStrategyValue, "#{name} Is Not A Known Value For #{self.class}"
			end
		end

	end
end