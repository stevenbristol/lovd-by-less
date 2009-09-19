# QueryStats::Holder

module QueryStats
  # QueryStatsHolder holds data on queries executed.
  # QueryStatsHolder#stats will return an array of hashes containing the following keys:
  # * type: The type of SQL query
  #   * delete
  #   * insert
  #   * select
  #   * update
  # * sql: The SQL executed.
  # * name: The name passed to the adapter's execute method, may be nil.
  # * seconds: The execution time in seconds.
  # * label: A custom label which can be set to track queries.
  class Holder
    LIMIT = 1_000
    # Gets or sets the current label to be applied to queries for custom tracking.
    # Including QueryStats in ApplicationController will label queries :controller or :view
    attr_accessor :label
  
    # Creates a new instance of QueryStats::Holder with an empty array of stats.
    def initialize
      @stats = []
    end

    # Add data to the array of stats - should only be called by the active record connection adapter.
    def add(sql, seconds, name = nil, *args) #:nodoc:
      @stats.shift if @stats.size >= LIMIT
      query_type = query_type_from_sql(sql)
      @stats << {
        :sql     => sql,
        :name    => name,
        :label   => @label,
        :seconds => seconds,
        :type    => query_type
      } if query_type
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
  
    # Return an array of query statistics collected.
    def stats
      @stats
    end
  
    # Return the total execution time for all queries in #stats.
    def runtime
      @stats.map { |query| query[:seconds] }.sum
    end
    alias :total_time :runtime
  
    def with_label(label)
      stats = @stats.select { |q| q[:label] == label }
    end
  
    # Returns an array of statistics for queries with a given type.
    def with_type(type)
      @stats.select { |q| q[:type] == type }
    end
    
    protected
    
    def query_type_from_sql(sql)
      case sql.upcase
      when /^SELECT/
        :select
      when /^INSERT/
        :insert
      when /^DELETE/
        :delete
      when /^UPDATE/
        :update
      else
        nil
      end
    end

  end
end
