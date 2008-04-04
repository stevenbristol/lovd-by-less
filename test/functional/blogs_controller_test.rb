require File.dirname(__FILE__) + '/../test_helper'

class BlogsControllerTest < ActionController::TestCase

  VALID_BLOG_POST = {
    :title => 'Valid Blog Post',
    :body => 'This is a valid blog post.'
  }
  
  OWNER_LINKS = ['(edit)', '(delete)', 'Write a new post', "&larr; Back to Dashboard"]
  
  def setup
    @controller = BlogsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  context 'on GET to :show' do
    should "render action when logged in as :owner" do
      do_show_assertions users(:user).id
      OWNER_LINKS.each {|l| assert_tag(:tag => 'a', :content => l)}
      assert_tag :tag => 'a', :content => 'Add a Comment'
    end
    
    should "render action when logged in as :user" do
      do_show_assertions users(:user2).id
      OWNER_LINKS.each {|l| assert_no_tag(:tag => 'a', :content => l)}
      assert_tag :tag => 'a', :content => 'Add a Comment'
    end
    
    should "render action when not logged in" do
      do_show_assertions
      OWNER_LINKS.each {|l| assert_no_tag(:tag => 'a', :content => l)}
      assert_no_tag :tag => 'a', :content => 'Add a Comment'
    end
  end
  
  context 'on GET to :index' do
    should "render action when logged in as :owner" do
      do_index_assertions users(:user).id, {:page => 7}
      OWNER_LINKS[2..-1].each {|l| assert_tag(:tag => 'a', :content => l)}
      assert_tag :tag => 'a', :content => 'Add a Comment'
    end
    
    should "render action when logged in as :user" do
      do_index_assertions users(:user2).id, {:page => 14}
      OWNER_LINKS[2..-1].each {|l| assert_no_tag(:tag => 'a', :content => l)}
      assert_tag :tag => 'a', :content => 'Add a Comment'
    end
    
    should "render action when not logged in" do
      do_index_assertions
      OWNER_LINKS[2..-1].each {|l| assert_no_tag(:tag => 'a', :content => l)}
      assert_no_tag :tag => 'a', :content => 'Add a Comment'
    end
  end
  
  context 'on GET to :new' do
    should "render action when logged in as :owner" do
      p = profiles(:user)
      get :new, {:profile_id => p.id}, {:user => p.user.id}
      assert_not_nil assigns(:blogs)
      assert assigns(:blog).new_record?
      assert_equal p, assigns(:profile)
      assert_equal Hash.new, flash
      assert_template 'new'
      assert_response :success
      assert_tag :content => '&larr; Back to Dashboard', :attributes => {:href=>profile_path(p)}
      assert_tag :content => '&larr; Back to Blogs', :attributes => {:href=>profile_blogs_path(p)}
    end
    
    should "redirect to home_path when logged in as :user" do
      p = profiles(:user)
      get :new, {:profile_id => p.id}, {:user => users(:user2).id}
      assert_nil assigns(:blogs)
      assert_equal 'It looks like you don\'t have permission to view that page.', flash[:error]
      assert_response :redirect
      assert_redirected_to home_path
    end
    
    should "redirect to login_path when not logged in" do
      p = profiles(:user)
      get :new, {:profile_id => p.id}
      assert_nil assigns(:blogs)
      assert_response :redirect
      assert_redirected_to login_path
    end
  end
  
  context 'on GET to :edit' do
    should "render action when logged in as :owner" do
      p = profiles(:user)
      b = p.blogs.first
      get :edit, {:profile_id => p.id, :id => b.id}, {:user => p.user.id}
      assert_not_nil assigns(:blogs)
      assert_equal b, assigns(:blog)
      assert_equal p, assigns(:profile)
      assert_equal Hash.new, flash
      assert_template 'edit'
      assert_response :success
      assert_tag :content => '&larr; Back to Dashboard', :attributes => {:href=>profile_path(p)}
      assert_tag :content => '&larr; Back to Blogs', :attributes => {:href=>profile_blogs_path(p)}
    end
    
    should "redirect to home_path when logged in as :user" do
      p = profiles(:user)
      b = p.blogs.first
      get :edit, {:profile_id => p.id, :id => b.id}, {:user => users(:user2).id}
      assert_equal 'It looks like you don\'t have permission to view that page.', flash[:error]
      assert_response :redirect
      assert_redirected_to home_path
    end
    
    should "redirect to login_path when not logged in" do
      p = profiles(:user)
      b = p.blogs.first
      get :new, {:profile_id => p.id, :id => b.id}
      assert_response :redirect
      assert_redirected_to login_path
    end
  end
  
  context 'on POST to :create' do
    should "redirect to profil_blogs_path with new blog when logged in as :owner" do
      p = profiles(:user)
      assert_difference "Blog.count" do
        post :create, {:profile_id => p.id, :blog => VALID_BLOG_POST}, {:user => p.user.id}
        assert_contains flash[:notice], /created/
        assert_response :redirect
        assert_redirected_to profile_blogs_path(p)
      end
    end
    
    should "render :new with error when logged in as :owner" do
      p = profiles(:user)
      assert_no_difference "Blog.count" do
        post :create, {:profile_id => p.id, :blog => VALID_BLOG_POST.merge(:body => '')}, {:user => p.user.id}
        assert_response :success
        assert_template 'new'
        assert assigns(:blog).new_record?
        assert !assigns(:blog).errors.empty?
      end
    end
    
    should "redirect to home_path when logged in as :user" do
      p = profiles(:user)
      post :create, {:profile_id => p.id, :blog => VALID_BLOG_POST}, {:user => users(:user2).id}
      assert_equal 'It looks like you don\'t have permission to view that page.', flash[:error]
      assert_response :redirect
      assert_redirected_to home_path
    end
    
    should "redirect to login_path when not logged in" do
      p = profiles(:user)
      post :create, {:profile_id => p.id, :blog => VALID_BLOG_POST}
      assert_response :redirect
      assert_redirected_to login_path
    end
  end
  
  context 'on PUT to :update' do
    should "redirect to profil_blogs_path with blog when logged in as :owner" do
      p = profiles(:user)
      b = p.blogs.first
      put :update, {:profile_id => p.id, :id=>b.id, :blog => VALID_BLOG_POST}, {:user => p.user.id}
      assert_contains flash[:notice], /updated/
      assert_response :redirect
      assert_redirected_to profile_blogs_path(p)
    end
    
    should "render :edit with error when logged in as :owner" do
      p = profiles(:user)
      b = p.blogs.first
      put :update, {:profile_id => p.id, :id=>b.id, :blog => VALID_BLOG_POST.merge(:title => '')}, {:user => p.user.id}
      assert_response :success
      assert_template 'edit'
      assert !assigns(:blog).errors.empty?
    end
    
    should "redirect to home_path when logged in as :user" do
      p = profiles(:user)
      b = p.blogs.first
      put :update, {:profile_id => p.id, :id=>b.id, :blog => VALID_BLOG_POST}, {:user => users(:user2).id}
      assert_equal 'It looks like you don\'t have permission to view that page.', flash[:error]
      assert_response :redirect
      assert_redirected_to home_path
    end
    
    should "redirect to login_path when not logged in" do
      p = profiles(:user)
      b = p.blogs.first
      put :update, {:profile_id => p.id, :id=>b.id, :blog => VALID_BLOG_POST}
      assert_response :redirect
      assert_redirected_to login_path
    end
  end
  
  context 'on DELETE to :destroy' do
    should "redirect to profil_blogs_path after deleting when logged in as :owner" do
      assert_difference "Blog.count", -1 do
        p = profiles(:user)
        b = p.blogs.first
        delete :destroy, {:profile_id => p.id, :id=>b.id}, {:user => p.user.id}
        assert_contains flash[:notice], /deleted/
        assert_response :redirect
        assert_redirected_to profile_blogs_path(p)
      end
    end
    
    should "redirect to home_path when logged in as :user" do
      p = profiles(:user)
      b = p.blogs.first
      put :update, {:profile_id => p.id, :id=>b.id}, {:user => users(:user2).id}
      assert_equal 'It looks like you don\'t have permission to view that page.', flash[:error]
      assert_response :redirect
      assert_redirected_to home_path
    end
    
    should "redirect to login_path when not logged in" do
      p = profiles(:user)
      b = p.blogs.first
      put :update, {:profile_id => p.id, :id=>b.id}
      assert_response :redirect
      assert_redirected_to login_path
    end
  end
  
  
  protected
  
  def do_show_assertions session_user_id = nil
    p = profiles(:user)
    b = profiles(:user).blogs.last
    get :show, {:profile_id => p.id, :id => b.id}, {:user => session_user_id}
    assert_not_nil assigns(:blogs)
    assert_equal b, assigns(:blog)
    assert_equal p, assigns(:profile)
    assert_equal Hash.new, flash
    assert_template 'show'
    assert_response :success
    assert_tag :tag => 'ul', :attributes => {:id => 'post_history'}, :children => {:count => 1, :only => {:tag => 'li'}}
    assert_tag :attributes => {:class=>'pagination'}
  end
  
  def do_index_assertions session_user_id = nil, opts = {}
    p = profiles(:user)
    get :index, {:profile_id => p.id}.merge(opts), {:user => session_user_id}
    assert_not_nil assigns(:blogs)
    assert assigns(:blog).new_record?
    assert_equal p, assigns(:profile)
    assert_equal Hash.new, flash
    assert_template 'index'
    assert_response :success
    assert_tag :tag => 'ul', :attributes => {:id => 'post_history'}, :children => {:count => 1, :only => {:tag => 'li'}}
    
    # tests object pagination for multiple pages in the view
    assert_tag :attributes => {:class=>'pagination'}
    if opts[:page]
      assert_tag :tag => 'span', :attributes => {:class => 'current'}, :content => opts[:page].to_s
    end
  end
end