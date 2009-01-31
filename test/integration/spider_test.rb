require "#{File.dirname(__FILE__)}/../test_helper"

class SpiderTest < ActionController::IntegrationTest
  fixtures :all
  include Caboose::SpiderIntegrator

  def test_spider_non_user
    puts ''
    puts 'test_spider_non_user'
    get "/"
    assert_response 200
  
    spider @response.body, '/', :ignore_forms=>[/\/profiles\/.*\/photos/]
  end
  
  
  def test_spider_user
    puts ''
    puts 'test_spider_user'
    get "/login"
    assert_response :success
    post "/login", :user=>{:login => users(:user).login, :password => 'test'}
    assert_response :redirect
    assert session[:user]
    assert_redirected_to :controller=>'profiles', :action=>'show', :id=>users(:user).profile.to_param
    follow_redirect!
  
    #   puts @response.body
    spider(@response.body, "/", :ignore_forms=>[/\/profiles\/.*\/photos/])
  end
  
  
  
  def test_spider_admin
    Profile.stubs(:search).returns(ThinkingSphinx::Collection.new(1, 1, 1, 1))
    puts ''
    puts 'test_spider_admin'
    get "/login"
    assert_response :success
    post "/login", :user=>{:login => users(:admin).login, :password => 'test'}
    assert_response :redirect
    assert session[:user]
    assert_redirected_to :controller=>'profiles', :action=>'show', :id=>users(:admin).profile.to_param
    follow_redirect!
  
    #   puts @response.body
    spider(@response.body, "/", :verbose=>false, :ignore_forms=>[/\/profiles\/.*\/photos/])
  end
  

end
