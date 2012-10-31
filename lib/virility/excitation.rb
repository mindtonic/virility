module Virility
  class Excitation
    include Virility::Supporter
    
    attr_accessor :url, :results, :strategies, :counts

    #
    # Initialization
    #

    def initialize url
      @url = url
      @strategies = {}
      @results = {}
      @counts = {}
      collect_strategies
    end

    #
    # Get Virility from all of the Strategies
    #

    def poll
      if @results.empty?
        @strategies.each do |name, strategy|
          begin
            @results[symbolize_for_key(strategy)] = strategy.poll
          rescue => e
            puts "[virility#poll] #{strategy.class.to_s} => #{e}"
          end
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
      poll
      if @counts.empty?
        @strategies.each do |name, strategy|
          begin
            @counts[symbolize_for_key(strategy)] = strategy.count.to_i
          rescue => e
            puts "[virility] #{strategy.class.to_s} => #{e}"
          end
        end
      end
      @counts
    end

    def total_virility
      counts.values.inject(0) { |result, count| result + count }
    end
    alias :total :total_virility

    #
    # Gather all of the Strategies
    #

    def collect_strategies
      Dir["#{File.dirname(__FILE__)}/strategies/**/*.rb"].each { |klass| @strategies[get_class_string(klass).to_sym] = Virility.const_get(camelize(get_class_string(klass))).new(@url) }
    end

    #
    # Reflection
    #

    def attributes
      {:url => @url, :available_strategies => @strategies.keys}
    end

    #
    # Dynamic Methods
    #

    def get_strategy strategy
      if strategy_exists?(strategy)
        @strategies[strategy.to_sym]
      else
        raise UnknownStrategy, "#{strategy} Is Not A Known Strategy"
      end
    end

    def strategy_exists? strategy
      !@strategies[strategy.to_sym].nil?
    end

    def method_missing(name, *args, &block)
      if strategy_exists?(name)
        get_strategy(name)
      else
        raise UnknownStrategy, "#{name} Is Not A Known Strategy"
      end
    end

  end
end