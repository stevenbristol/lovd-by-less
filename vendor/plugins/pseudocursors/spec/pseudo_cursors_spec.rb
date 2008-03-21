require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require File.expand_path(File.dirname(__FILE__) + '/../init.rb')

class MockCursorClass
  include PseudoCursors
  
  def self.primary_key
    'mock_id'
  end
end

context "PseudoCursors Plugin" do
  
  setup do
  end
  
  specify "should inject find_each method in ActiveRecord" do
    ActiveRecord::Base.respond_to?(:find_each).should == true
  end
  
  specify "should return immediately if no block given" do
    MockCursorClass.should_not_receive(:select_cursor_ids)
    MockCursorClass.find_each.should == nil
  end
  
  specify "should yield to the block given with a record" do
    MockCursorClass.should_receive(:select_cursor_ids).and_return([0, 1, 2])
    MockCursorClass.should_receive(:find).and_return(['a', 'b', 'c'])
    arr = []
    MockCursorClass.find_each{|r| arr << r}
    arr.should == ['a', 'b', 'c']
  end
  
  specify "should pass through find options to select_all" do
    find_options = {:conditions => {:col => 1}, :limit => 100}
    MockCursorClass.stub!(:table_name).and_return('mock_table')
    MockCursorClass.should_receive(:construct_finder_sql).with(find_options.merge(:select => 'mock_table.mock_id'))
    connection = mock('connection')
    connection.should_receive(:select_all).and_return([{'id' => '0'}, {'id' => '1'}, {'id' => '3'}])
    MockCursorClass.should_receive(:connection).and_return(connection)
    MockCursorClass.should_receive(:find).twice.and_return(['a', 'b'])
    MockCursorClass.find_each(find_options.merge(:batch_size => 2, :transaction => false)){|r|}
  end
  
  specify "should allow batch_size to be specified" do
    MockCursorClass.should_receive(:select_cursor_ids).with(:conditions => {:col => 'val'}).and_return([0, 1, 2, 4])
    MockCursorClass.should_receive(:find).twice.and_return(['a', 'b'])
    MockCursorClass.find_each(:batch_size => 2, :conditions => {:col => 'val'}){|r|}
  end
  
  specify "should get records in groups by batch size by ids" do
    MockCursorClass.should_receive(:select_cursor_ids).and_return([0, 1, 2, 4])
    MockCursorClass.should_receive(:find).twice.and_return(['a', 'b'])
    MockCursorClass.find_each(:batch_size => 2){|r|}
  end
  
  specify "should order results if :order is specified" do
    find_options = {:order => 'col'}
    MockCursorClass.stub!(:table_name).and_return('mock_table')
    MockCursorClass.should_receive(:construct_finder_sql).with(find_options.merge(:select => 'mock_table.mock_id'))
    connection = mock('connection')
    connection.should_receive(:select_all).and_return([{'id' => '0'}, {'id' => '1'}])
    MockCursorClass.should_receive(:connection).and_return(connection)
    MockCursorClass.should_receive(:find).and_return(['a', 'b'])
    MockCursorClass.should_receive(:sort_cursor_rows!).with(['a', 'b'], [0, 1]).and_return(['a', 'b'])
    MockCursorClass.find_each(:order => 'col'){|r|}
  end
  
  specify "sorting by original id order should work" do
    a = mock('row')
    a.stub!(:id).and_return(1)
    b = mock('row')
    b.stub!(:id).and_return(2)
    c = mock('row')
    c.stub!(:id).and_return(3)
    d = mock('row')
    d.stub!(:id).and_return(4)
    rows = [d, a, c, b]
    MockCursorClass.send(:sort_cursor_rows!, rows, [1, 2, 3, 4])
    rows.should == [a, b, c, d]
  end
  
  specify "should wrap in transactions if specified" do
    MockCursorClass.should_receive(:select_cursor_ids).with(:conditions => {:col => 'val'}).and_return([0, 1, 2, 4])
    MockCursorClass.should_receive(:find).twice.and_return(['a', 'b'])
    MockCursorClass.should_receive(:transaction).twice
    MockCursorClass.find_each(:batch_size => 2, :transaction => true, :conditions => {:col => 'val'}){|r|}
  end
  
  specify "should not wrap in transactions if not specified" do
    MockCursorClass.should_receive(:select_cursor_ids).and_return([0, 1, 2, 4])
    MockCursorClass.should_receive(:find).twice.and_return(['a', 'b'])
    MockCursorClass.should_not_receive(:transaction)
    MockCursorClass.find_each(:batch_size => 2, :transaction => false){|r|}
  end
  
  specify "should return nil" do
    MockCursorClass.should_receive(:select_cursor_ids).and_return([0])
    MockCursorClass.should_receive(:find).and_return([mock('record')])
    MockCursorClass.find_each{|r|}.should == nil
  end
  
end
