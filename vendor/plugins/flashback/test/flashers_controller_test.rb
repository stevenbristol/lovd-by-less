require File.expand_path(File.dirname(__FILE__) + "/test_helper")

class FlashersControllerTest < ActionController::TestCase
  
  def test_flash_available_after_request
    get :index, :actual_flash => 'hello'
    assert_equal 'hello', flash[:actual_flash]
  end

  def test_flash_now_not_available_after_request
    get :index, :actual_flash_now => 'world'
    assert_nil flash.now[:actual_flash_now]
  end

  def test_no_flashback_means_flash_now_not_available_after_request_via_flashed
    get :index, :actual_flash_now => 'world'
    assert_raise(NoMethodError) {flash.flashed[:actual_flash_now]}
  end

  def test_flash_now_is_available_after_request_via_flashed
    flashback
    get :index, :actual_flash_now => 'world'
    assert_equal 'world', flash.flashed[:actual_flash_now]
  end

  def test_flash_not_available_after_request_via_flashed
    # Flash variables are not available via _flashed_ after the request has 
    # finished because they have not yet been discarded. Only discarded 
    # key/value pairs are available via _flashed_
    flashback
    get :index, :actual_flash => 'hello'
    assert_nil flash.flashed[:actual_flash]
  end

end
