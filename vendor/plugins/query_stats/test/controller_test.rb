require File.expand_path(File.dirname(__FILE__) + "/test_helper")

class ControllerTest < Test::Unit::TestCase
  include QueryStats::Helper
  
  def setup
    ActionController::Routing::Routes.draw { |map| map.connect ':controller/:action' }
    @controller = Class.new(ActionController::Base) do
      def controller_queries
        3.times { Person.count }
        render :nothing => true
      end
      def view_queries
        render :inline => "<% 5.times { Person.count } %>"
      end
      def both
        2.times { Person.count }
        render :inline => '<% 4.times { Person.count } %>'
      end
      def use_helper
        Person.count
        render :inline => '<%= queries.count %>'
      end
    end.new
    @request  = ActionController::TestRequest.new
    @response = ActionController::TestResponse.new
    ActionController::Base.logger = Logger.new(@log = StringIO.new)
  end
  
  def test_queries_in_controller
    get :controller_queries
    assert @response.success?
    
    assert_equal 3, queries.count_with_label(:controller)
    assert_equal 0, queries.count_with_label(:view)
    assert_equal 3, queries.count
  end
  
  def test_queries_in_view
    get :view_queries
    assert @response.success?
    
    assert_equal 0, queries.count_with_label(:controller)
    assert_equal 5, queries.count_with_label(:view)
    assert_equal 5, queries.count
  end
  
  def test_queries_in_both
    get :both
    assert @response.success?
    
    assert_equal 2, queries.count_with_label(:controller)
    assert_equal 4, queries.count_with_label(:view)
    assert_equal 6, queries.count
  end
  
  def test_using_helper
    get :use_helper
    assert @response.success?
    assert_equal "1", @response.body
  end
  
  def test_logger
    get :both
    assert @response.success?
    
    assert_match /6 queries/, @log.string
  end
end