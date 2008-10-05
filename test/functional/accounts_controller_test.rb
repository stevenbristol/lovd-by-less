require File.dirname(__FILE__) + '/../test_helper'

class AccountsControllerTest < ActionController::TestCase

  VALID_USER = {
    :login => 'lquire',
    :email => 'lquire@example.com',
    :password => 'lquire', :password_confirmation => 'lquire',
    :terms_of_service=>'1'
  }
  
  def setup
    @controller = AccountsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  context 'A visitor' do
    should 'be able to signup' do
      assert_difference "User.count" do
        post :signup, {:user => VALID_USER}
        assert_response :redirect
        assert assigns['u']
        assert_redirected_to profile_path(assigns['u'].profile)
        assert_equal 'Thanks for signing up!', flash[:notice]
      end
    end
  end

  def test_should_login_and_redirect
    post :login, :user=>{:login => 'user', :password => 'test'}
    assert session[:user]
    assert assigns['u']
    assert_response :redirect
    assert_redirected_to profile_path(assigns['u'].profile)
  end

  def test_should_fail_login_and_not_redirect
    post :login, :user=>{:login => 'user', :password => 'bad password'}
    assert_nil session[:user]
    assert_response :success
  end
  
  
  
  
  def test_forgot_no_email
    flashback
    post :login, :user=>{:email=>'asdf'}
    assert_nil session[:user]
    assert_response :success
    assert_equal nil, flash[:notice]
    assert_equal "Could not find that email address. Try again.", flash.flashed[:error] 
  end
  
  
  
  def test_forgot_good_email
    flashback
    assert u = users(:user)
    assert p = u.crypted_password
    post :login, :user=>{:email=>profiles(:user).email}
    assert_nil session[:user]
    assert_response :success
    assert_equal nil, flash[:error] 
    assert_equal "A new password has been mailed to you.", flash.flashed[:notice] 
    assert_not_equal(assigns(:p), u.crypted_password)
  end
  

  def test_should_allow_signup
    assert_difference "User.count" do
      create_user
      assert_response :redirect
    end
    assert_not_nil(assigns(:u))
    assert_not_nil(assigns(:u).profile)
  end

  def test_should_require_login_on_signup
    assert_no_difference "User.count" do
      create_user(:login => nil)
      assert assigns(:u).errors.on(:login)
      assert_response :success
    end
  end

  def test_should_require_password_on_signup
    assert_no_difference "User.count" do
      create_user(:password => nil)
      assert assigns(:u).errors.on(:password)
      assert_response :success
    end
  end

  def test_should_require_password_confirmation_on_signup
    assert_no_difference "User.count" do
      create_user(:password_confirmation => nil)
      assert assigns(:u).errors.on(:password_confirmation)
      assert_response :success
    end
  end
  
  def test_should_fail_signup_cuz_no_terms
    flashback
    assert_no_difference "User.count" do
      post :signup, {
        :user => { 
          :login => 'lquire',
          :email => 'lquire@example.com',
          :password => 'lquire',
          :password_confirmation => 'lquire',
          :terms_of_service => '0'
          }
        }
    end
    assert assigns(:user).errors.on(:terms_of_service)
    assert_response :success
    assert assigns(:u)
    assert assigns(:u).new_record?
  end
  
  
  def test_should_fail_signup_cuz_captcha
    flashback
    assert_no_difference "User.count" do
      post :signup, {
        :user => { 
          :login => 'lquire',
          :email => 'lquire@example.com',
          :password => 'lquire',
          :password_confirmation => 'lquire',
          :terms_of_service => '1',
          :less_value_for_text_input=>'1'
          }
        }
    end
    assert assigns(:user).errors.on(:you)
    assert_response :success
    assert assigns(:u)
    assert assigns(:u).new_record?
  end
  
  def test_should_require_email_on_signup
    assert_no_difference "User.count" do
      create_user(:email => nil)
      assert assigns(:user).errors.on(:email)
      assert_response :success
    end
  end

  def test_should_logout
    login_as :user
    get :logout
    assert_nil session[:user]
    assert_response :redirect
    assert_redirected_to home_url
  end

  def test_should_remember_me
    post :login, :user=>{:login => 'user', :password => 'test', :remember_me => "1"}
    assert_not_nil @response.cookies["auth_token"]
  end

  def test_should_not_remember_me
    post :login, :user=>{:login => 'quentin', :password => 'test', :remember_me => "0"}
    assert_nil @response.cookies["auth_token"]
  end
  
  def test_should_delete_token_on_logout
    login_as :user
    get :logout
    assert_equal [], @response.cookies["auth_token"]
  end

  def test_should_login_with_cookie
    users(:user).remember_me
    @request.cookies["auth_token"] = cookie_for(:user)
    get :login
    assert @controller.send(:logged_in?)
  end

  def test_should_fail_expired_cookie_login
    users(:user).remember_me
    users(:user).update_attribute :remember_token_expires_at, 5.minutes.ago.utc
    @request.cookies["auth_token"] = cookie_for(:user)
    get :login
    assert !@controller.send(:logged_in?)
  end

  def test_should_fail_cookie_login
    users(:user).remember_me
    @request.cookies["auth_token"] = auth_token('invalid_auth_token')
    get :login
    assert !@controller.send(:logged_in?)
  end

  protected
    def create_user(options = {}, signup_code = '1234')
      post :signup, {:user => { :login => 'lquire', :email => 'lquire@example.com',
        :password => 'lquire', :password_confirmation => 'lquire', :terms_of_service => '1' }.merge(options)}
    end
    
    def auth_token(token)
      CGI::Cookie.new('name' => 'auth_token', 'value' => token)
    end
    
    def cookie_for(user)
      auth_token users(user).remember_token
    end
end
