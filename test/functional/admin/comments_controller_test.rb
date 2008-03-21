require File.dirname(__FILE__) + '/../../test_helper'

# Re-raise errors caught by the controller.
class Admin::CommentsController; def rescue_action(e) raise e end; end

class Admin::CommentsControllerTest < Test::Unit::TestCase
  fixtures :users, :profiles, :comments
  def setup
    @controller = Admin::CommentsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end
  
  def test_truth
    true
  end



end
