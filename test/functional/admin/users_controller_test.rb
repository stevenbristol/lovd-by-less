require File.dirname(__FILE__) + '/../../test_helper'

# Re-raise errors caught by the controller.
class Admin::UsersController; def rescue_action(e) raise e end; end

class Admin::UsersControllerTest < Test::Unit::TestCase
  fixtures :users, :profiles

  def setup
    @controller = Admin::UsersController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

  end
  
  
  
  def test_truth
    true
  end




end
