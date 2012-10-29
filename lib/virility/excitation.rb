module Virility
	class Excitation
		attr_accessor :url, :results, :strategies, :counts

		#
		# Initialization
		#

		def initialize url
			@url = encode url
			@strategies = {}
			@results = {}
			@counts = {}
			collect_strategies
		end

		#
		# Get Virility from all of the Strategies
		#

		def get_virility
			@strategies.each do |name, strategy|
				begin
					@results[symbolize_for_key(strategy)] = strategy.get_virility
				rescue => e
					puts "[virility] #{strategy.class.to_s} => #{e}"
				end
			end
			@results
		end

		def get_response(strategy)
			@strategies[strategy].response if @strategies[strategy]
		end
		
		#
		# Return Collected Counts as a Hash
		#
		
		def counts
			@strategies.each do |name, strategy|
				begin
					@counts[symbolize_for_key(strategy)] = strategy.count.to_i
				rescue => e
					puts "[virility] #{strategy.class.to_s} => #{e}"
				end
			end
			@counts
		end

		#
		# Gather all of the Strategies
		#

		def collect_strategies
			Dir["#{File.dirname(__FILE__)}/strategies/**/*.rb"].each { |klass| @strategies[get_class_string(klass).to_sym] = Virility.const_get(camelize(get_class_string(klass))).new(@url) }
		end

		#
		# URL Encoding / Decoding Methods
		#

		def encode url
			CGI.escape url
		end

		def url
			CGI.unescape @url
		end

		def escaped_url
			@url
		end

		#
		# Camelize
		#

		def camelize(lower_case_and_underscored_word, first_letter_in_uppercase = true)
		  if first_letter_in_uppercase
		    lower_case_and_underscored_word.to_s.gsub(/\/(.?)/) { "::" + $1.upcase }.gsub(/(^|_)(.)/) { $2.upcase }
		  else
		    lower_case_and_underscored_word.first + camelize(lower_case_and_underscored_word)[1..-1]
		  end
		end

		#
		# Convert Class Name To Appropriate Key Symbol
		#

		def symbolize_for_key(klass)
			klass.class.to_s.gsub(/Virility::/, '').downcase.to_sym
		end

		def get_class_string(klass)
			File.basename(klass).gsub(/\.rb/,'')
		end

		#
		# Reflection
		#

		def attributes
			{:url => @url}
		end

	end
end