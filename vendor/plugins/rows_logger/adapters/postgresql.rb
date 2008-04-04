ActiveRecord::ConnectionAdapters::PostgreSQLAdapter.class_eval do
  protected
  def count_result(result)
    if result.is_a?(PGresult)
      result.num_tuples
    else
      nil
    end
  end
end