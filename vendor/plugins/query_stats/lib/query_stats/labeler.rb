# QueryStats::Labeler

module QueryStats
  # Automatically labels queries as to whether they were executed
  # in the controller or in the view.
  module Labeler
    protected
    
    # When the controller logs processing, QueryStats clears existing statistics.
    def log_processing_with_query_stats()
      queries.clear
      queries.label = :controller
      log_processing_without_query_stats
    end

    # When rendering starts, start labeling queries with :view
    def render_with_query_stats(*args, &block)
      queries.label = :view
      render_without_query_stats(*args, &block)
    end

    # Returns the QueryStats::Holder for the current database connection.
    def queries #:nodoc:
      ActiveRecord::Base.connection.queries
    end
    
    def self.included(base) #:nodoc:
      base.class_eval do
        alias_method_chain_unless_defined :log_processing, :query_stats
        alias_method_chain_unless_defined :render, :query_stats
      end
    end

  end
end