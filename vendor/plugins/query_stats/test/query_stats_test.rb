require File.expand_path(File.dirname(__FILE__) + "/test_helper")

class QueryStatsTest < Test::Unit::TestCase
  include QueryStats::Helper
  fixtures :people

  def setup
    queries.clear
    raise "setup failed" unless queries.count == 0
  end
  
  def test_columns_query_ignored
    Person.reset_column_information
    Person.columns
    assert queries.stats.empty?
  end
  
  def test_select_query_for_count
    Person.count
    assert_equal :select, queries.stats.last[:type]
  end
  
  def test_select_query_for_find_by_sql
    ActiveRecord::Base.find_by_sql("SELECT * FROM people")
    stats = queries.stats.last
    assert_equal :select, stats[:type]
    assert_equal "SELECT * FROM people", stats[:sql]
  end
  
  def test_delete_query
    Person.delete_all
    assert_equal :delete, queries.stats.last[:type]
  end
  
  def test_insert_query
    Person.create!(:name => "John Doe")
    assert_equal :insert, queries.stats.last[:type]
    assert_match /insert/i, queries.stats.last[:sql]
  end
  
  def test_update_query
    Person.update(1, :name => "Anonymous")
    assert_equal :update, queries.stats.last[:type]
    assert_match /update/i, queries.stats.last[:sql]
  end
  
  def test_count_and_clear
    Person.count
    assert_equal 1, queries.count
    queries.clear
    assert_equal 0, queries.count
  end
  
  def test_label
    queries.label = :test_label
    Person.find(:first)
    queries.label = :test_label2
    3.times { Person.find(:first) }
    assert_equal 4, queries.count
    assert_equal 1, queries.count_with_label(:test_label)
    assert_equal 3, queries.count_with_label(:test_label2)
  end
  
  def test_count_with_type
    1.times { Person.find(:first) }
    2.times { Person.update_all("name = 'Dan Manges'") }
    3.times { Person.create!(:name => "Dan Manges") }
    4.times { Person.delete_all }
    assert_equal 1, queries.count_with_type(:select)
    assert_equal 2, queries.count_with_type(:update)
    assert_equal 3, queries.count_with_type(:insert)
    assert_equal 4, queries.count_with_type(:delete)
  end
  
  def test_holder_limit
    silence_warnings { QueryStats::Holder.const_set 'LIMIT', 5 }
    10.times { Person.count }
    assert_equal 5, queries.count
  end

end