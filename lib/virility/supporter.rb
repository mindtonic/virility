module Virility
	module Supporter

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
		# Camelize / Underscore
		#

		def camelize(lower_case_and_underscored_word, first_letter_in_uppercase = true)
		  if first_letter_in_uppercase
		    lower_case_and_underscored_word.to_s.gsub(/\/(.?)/) { "::" + $1.upcase }.gsub(/(^|_)(.)/) { $2.upcase }
		  else
		    lower_case_and_underscored_word.first + camelize(lower_case_and_underscored_word)[1..-1]
		  end
		end

		def underscore(camel_cased_word)
			word = camel_cased_word.to_s.dup
			word.gsub!(/::/, '/')
			word.gsub!(/([A-Z]+)([A-Z][a-z])/,'\1_\2')
			word.gsub!(/([a-z\d])([A-Z])/,'\1_\2')
			word.tr!("-", "_")
			word.downcase!
			word
		end

		#
		# Convert Class Name To Appropriate Key Symbol
		#

		def symbolize_for_key(klass)
			underscore(klass.class.to_s.gsub(/Virility::/, '')).to_sym
		end

		def get_class_string(klass)
			File.basename(klass).gsub(/\.rb/,'')
		end

	end
end