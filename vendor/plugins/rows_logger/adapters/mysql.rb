ActiveRecord::ConnectionAdapters::MysqlAdapter.class_eval do
  protected
  def count_result(result)
    result.num_rows
  end
end