module QueryStats
  module Recorder
    def self.included(base)
      base.class_eval do
        alias_method_chain :execute, :query_stats
      end
    end
    
    def queries
      @query_stats ||= QueryStats::Holder.new
    end
    
    def execute_with_query_stats(*args)
      result = nil
      seconds = Benchmark.realtime do
        result = execute_without_query_stats(*args)
      end
      queries.add(args.first, seconds, *args[1..-1])
      result
    end
  end
end
