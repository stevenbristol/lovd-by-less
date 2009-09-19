module QueryStats
  module Helper
    def queries
      ActiveRecord::Base.connection.queries
    end
  end
end
