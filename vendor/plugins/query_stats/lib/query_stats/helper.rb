# QueryStats::Helper

module QueryStats
  # Helper methods to access query stats data.
  module Helper
    # Provides access to the QueryStatsHolder
    def queries
      ActiveRecord::Base.connection.queries
    end
  end
end
