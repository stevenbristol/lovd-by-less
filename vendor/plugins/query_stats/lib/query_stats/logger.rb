# QueryStats::Logger

module QueryStats
  # Adds the query count to the log;
  module Logger
    protected
    # Append the query count to the active record data.
    def active_record_runtime_with_query_stats(*args, &block)
      active_record_runtime_without_query_stats(*args, &block) << " #{ActiveRecord::Base.connection.queries.count} queries"
    end
  
    def self.included(base) #:nodoc:
      base.class_eval do
        alias_method_chain_unless_defined :active_record_runtime, :query_stats
      end
    end
  end
end
