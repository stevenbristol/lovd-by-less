require "#{File.dirname(__FILE__)}/../test_helper"

class SpiderTest < ActionController::IntegrationTest
  fixtures :all
  include Caboose::SpiderIntegrator

  def test_spider_non_user
    puts ''
    puts 'test_spider_non_user'
    get "/"
    assert_response 200
  
    spider(@response.body, '/', false)
  end
  
  
  def test_spider_aa_user
    puts ''
    puts 'test_spider_user'
    get "/login"
    assert_response :success
    post "/login", :user=>{:login => users(:user).login, :password => 'test'}
    assert_response :redirect
    assert session[:user]
    assert_redirected_to profile_url(users(:user).profile)
    follow_redirect!
  
    #   puts @response.body
    spider(@response.body, "/", false)
  end

  
  
  def test_spider_admin
    puts ''
    puts 'test_spider_admin'
    get "/login"
    assert_response :success
    post "/login", :user=>{:login => users(:admin).login, :password => 'test'}
    assert_response :redirect
    assert session[:user]
    assert_redirected_to profile_url(users(:admin).profile)
    follow_redirect!
  
    #   puts @response.body
    spider(@response.body, "/", false)
  end


end
