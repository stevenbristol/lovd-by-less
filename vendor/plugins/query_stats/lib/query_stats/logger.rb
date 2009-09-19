module QueryStats
  module Logger
    def self.included(base)
      base.class_eval do
        alias_method_chain :active_record_runtime, :query_stats
        alias_method_chain :perform_action, :query_stats
      end
    end

    protected

    def active_record_runtime_with_query_stats(*args, &block)
      active_record_runtime_without_query_stats(*args, &block) << " #{ActiveRecord::Base.connection.queries.count} queries"
    end
    
    def perform_action_with_query_stats
      perform_action_without_query_stats
      response.headers["X-QueryCount"] = ActiveRecord::Base.connection.queries.count.to_s
      response.headers["X-QueryRuntime"] = "%.5f" % ActiveRecord::Base.connection.queries.runtime.to_s
    end
  
  end
end
