# QueryStats::Recorder

module QueryStats
  # Captures query data from ActiveRecord::Base.
  module Recorder
    QUERY_METHODS = [
      :begin_db_transaction,
      :columns,
      :commit_db_transaction,
      :delete,
      :insert,
      :rollback_db_transaction,
      :select_all,
      :select_one,
      :select_value,
      :select_values,
      :update
    ]
    def self.included(base) #:nodoc:
      base.class_eval do
        QUERY_METHODS.each do |method|
          define_method("#{method}_with_query_stats") do |*args|
            queries.query_type = method
            send "#{method}_without_query_stats", *args
          end
          alias_method_chain_unless_defined method, :query_stats
        end
        alias_method_chain_unless_defined :execute, :query_stats
      end
    end
    
    # Returns or initializes the QueryStats::Holder
    def queries
      @query_stats ||= QueryStats::Holder.new
    end
    
    # Executes the query, capturing execution time and logging data to the
    # QueryStats::Holder
    def execute_with_query_stats(*args)
      result = nil
      seconds = Benchmark.realtime do
        result = execute_without_query_stats(*args)
      end
      queries.add(seconds, *args)
      result
    end
  end
end