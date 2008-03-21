# QueryStats::Holder

module QueryStats
  # QueryStatsHolder holds data on queries executed.
  # QueryStatsHolder#stats will return an array of hashes containing the following keys:
  # * type: The type of SQL query based on methods in ActiveRecord::ConnectionAdapters::AbstractAdapter
  #   * begin_db_transaction
  #   * columns
  #   * commit_db_transaction
  #   * delete
  #   * insert
  #   * rollback_db_transaction
  #   * select
  #   * update
  # * sql: The SQL executed.
  # * name: The name passed to the adapter's execute method, may be nil.
  # * seconds: The execution time in seconds.
  # * label: A custom label which can be set to track queries.
  class Holder
    LIMIT = 100
    # Gets or sets the current label to be applied to queries for custom tracking.
    # Including QueryStats in ApplicationController will label queries :controller or :view
    attr_accessor :label
    # Gets the current query type
    attr_reader   :query_type
  
    # Creates a new instance of QueryStats::Holder with an empty array of stats.
    def initialize
      @ignore_types = [
        :begin_db_transaction,
        :columns,
        :commit_db_transaction,
        :rollback_db_transaction
      ]
      @stats = []
    end

    # Add data to the array of stats - should only be called by the active record connection adapter.
    def add(seconds, query, name = nil, *args) #:nodoc:
      @stats.shift if @stats.size >= LIMIT
      @stats << {
        :sql     => query,
        :name    => name,
        :label   => @label,
        :seconds => seconds,
        :type    => @query_type
      }
    end

    # Remove the current label and clear the array of stats.
    def clear
      @label = nil
      @stats.clear
    end
  
    # Return the number of queries captured.
    def count
      @stats.length
    end
  
    # Return the number of queries executed with a given label.
    def count_with_label(label)
      with_label(label).length
    end
  
    # Return the number of queries executed with a given type.
    def count_with_type(type)
      with_type(type).length
    end
  
    # Set the query type - this should only be called automatically from the connection adapter.
    def query_type=(sym) #:nodoc:
      @query_type = sym
      @query_type = :select if @query_type.to_s =~ /select/
    end
  
    # Return an array of query statistics collected.
    def stats
      @stats
    end
  
    # Return the total execution time for all queries in #stats.
    def runtime
      @stats.inject(0) { |sum,query| sum + query[:seconds] }
    end
    alias :total_time :runtime
  
    # Returns an array of statistics for queries with a given label.
    # Set ignore to false to include transaction and column queries.
    def with_label(label, ignore = true)
      stats = @stats.select { |q| q[:label] == label }
      ignore ? stats.reject { |q| @ignore_types.include?(q[:type]) } : stats
    end
  
    # Returns an array of statistics for queries with a given type.
    def with_type(type)
      @stats.select { |q| q[:type] == type }
    end

  end
end