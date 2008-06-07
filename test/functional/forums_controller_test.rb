##
# ForumsController tests
# Author: Les Freeman (lesliefreeman3@gmail.com)
#

require File.dirname(__FILE__) + '/../test_helper'

class ForumsControllerTest < ActionController::TestCase

  include ForumsTestHelper
  
  ##
  # :index
  
  should "get the index as guest" do
    assert_nothing_raised do
      get :index, {}
      assert_response 200
      assert_template 'index'
      
      assert_no_tag :tag => 'a', :content => "Create a new forum"
      forums.each do |forum|
        assert_no_tag :tag => "a", :attributes => {:href => forum_url(forum), :class => "destroy"},
                                   :parent => {:tag => "div", :attributes => {:id => dom_id(forum)}}
        assert_no_tag :tag => "a", :attributes => {:href => edit_forum_url(forum)},
                                   :parent => {:tag => "div", :attributes => {:id => dom_id(forum)}}
      end
    end
  end
  
  should "get the index as :user" do
    assert_nothing_raised do
      get :index, {}, {:user => profiles(:user).id}
      assert_response 200
      assert_template 'index'
      assert_no_tag :tag => 'a', :content => "Create a new forum"
      forums.each do |forum|
        assert_no_tag :tag => "a", :attributes => {:href => forum_url(forum), :class => "destroy"},
                                   :parent => {:tag => "div", :attributes => {:id => dom_id(forum)}}
        assert_no_tag :tag => "a", :attributes => {:href => edit_forum_url(forum)},
                                   :parent => {:tag => "div", :attributes => {:id => dom_id(forum)}}
      end
    end
  end

  should "get the index as :admin" do
    assert_nothing_raised do
      get :index, {}, {:user => profiles(:admin).id}
      assert_response 200
      assert_template 'index'
      assert_tag :tag => 'a', :content => "Create a new forum"
      forums.each do |forum|
        assert_tag :tag => "a", :attributes => {:href => forum_url(forum), :class => "destroy"},
                                :parent => {:tag => "div", :attributes => {:id => dom_id(forum)}}
                                
        assert_tag :tag => "a", :attributes => {:href => edit_forum_url(forum)},
                                :parent => {:tag => "div", :attributes => {:id => dom_id(forum)}}
      end
    end
  end


  ##
  # :show
  
  should "get show as guest" do
    assert_nothing_raised do
      get :show, {:id => forums(:one)}
      assert_response 200
      assert_template 'show'
      
      assert_no_tag :tag => 'a', :attributes => {:id => "new_topic_link"}
      assert_tag :tag => "a", :attributes => {:href => signup_path}, 
                 :ancestor => {:tag => "div", :attributes => {:class => "forum"}}
      assert_tag :tag => "a", :attributes => {:href => login_path},
                 :ancestor => {:tag => "div", :attributes => {:class => "forum"}}
                    
      forums(:one).topics.each do |topic|
        assert_no_tag :tag => "a", :attributes => {:id => "forum_topic_#{topic.id}_destroy_link"}
        assert_no_tag :tag => "a", :content => "Edit", :attributes => {:id => "forum_topic_#{topic.id}_edit_link"}
      end
    end
  end
  
  should "get show as :user" do
    assert_nothing_raised do
      get :show, {:id => forums(:one)}, {:user => profiles(:user).id}
      assert_response 200
      assert_template 'show'
      
      assert_tag :tag => 'a', :attributes => {:id => "new_topic_link"}
      assert_no_tag :tag => "a", :attributes => {:href => signup_path}, 
                    :ancestor => {:tag => "div", :attributes => {:class => "forum"}}
      assert_no_tag :tag => "a", :attributes => {:href => login_path},
                    :ancestor => {:tag => "div", :attributes => {:class => "forum"}}
      forums(:one).topics.each do |topic|
        assert_no_tag :tag => "a", :attributes => {:id => "forum_topic_#{topic.id}_destroy_link"}
        assert_no_tag :tag => "a", :content => "Edit", :attributes => {:id => "forum_topic_#{topic.id}_edit_link"}
      end
    end
  end

  should "get show as :admin" do
    assert_nothing_raised do
      get :show, {:id => forums(:one)}, {:user => profiles(:admin).id}
      assert_response 200
      assert_template 'show'
      
      assert_no_tag :tag => "a", :attributes => {:href => signup_path}, 
                    :ancestor => {:tag => "div", :attributes => {:class => "forum"}}
      assert_no_tag :tag => "a", :attributes => {:href => login_path},
                    :ancestor => {:tag => "div", :attributes => {:class => "forum"}}
      
      assert_tag :tag => 'a', :attributes => {:id => "new_topic_link"}
      forums(:one).topics.each do |topic|
        assert_tag :tag => "a", :attributes => {:id => "forum_topic_#{topic.id}_destroy_link"}
        assert_tag :tag => "a", :content => "Edit", :attributes => {:id => "forum_topic_#{topic.id}_edit_link"}
      end
    end
  end
  
  ##
  # :new
  
  should "not get new for guest" do
    assert_nothing_raised do
      get :new, {}
      assert_response 302
      assert_redirected_to :login_path
    end
  end

  should "not get new for :user" do
    assert_nothing_raised do
      get :new, {}, {:user => profiles(:user).id}
      assert_response 302
      assert flash[:error]
    end
  end
  
  should "get new for :admin" do
    assert_nothing_raised do
      get :new, {}, {:user => profiles(:admin).id}
      assert_response 200
      assert_template 'new'
    end
  end
  
  ##
  # create
  
  should "not create a new forum for guest" do
    assert_nothing_raised do
      assert_no_difference "Forum.count" do
        post :create, {:forum => valid_forum_attributes}
        assert_response 302
        assert_redirected_to :login_path
      end
    end
  end
  
  should "not create a new forum for :user" do
    assert_nothing_raised do
      assert_no_difference "Forum.count" do
        post :create, {:forum => valid_forum_attributes}, {:user => profiles(:user).id}
        assert_response 302
        assert flash[:error]
      end
    end
  end

  should "create a new forum for :admin" do
    assert_nothing_raised do
      assert_difference "Forum.count" do
        post :create, {:forum => valid_forum_attributes}, {:user => profiles(:admin).id}
        assert_redirected_to :controller => 'forums', :action => 'show'
      end
    end
  end
  
  ##
  # :edit
  
  should "not get edit for guest" do
    assert_nothing_raised do
      get :edit, {:id => forums(:one).id}
      assert_response 302
      assert_redirected_to :login_path
    end
  end

  should "not get edit for :user" do
    assert_nothing_raised do
      get :edit, {:id => forums(:one).id}, {:user => profiles(:user).id}
      assert_response 302
      assert flash[:error]
    end
  end
  
  should "get edit for :admin" do
    assert_nothing_raised do
      get :edit, {:id => forums(:one).id}, {:user => profiles(:admin).id}
      assert_response 200
      assert_template 'edit'
    end
  end
  
  ##
  # :update
  
  should "not update a forum for guest" do
    assert_nothing_raised do
      put :update, {:id => forums(:one).id, :forum => valid_forum_attributes}
      assert_response 302
      assert_redirected_to :login_path
    end
  end
  
  should "not update a forum for :user" do
    assert_nothing_raised do
      put :update, {:id => forums(:one).id, :forum => valid_forum_attributes}, {:user => profiles(:user).id}
      assert_response 302
      assert flash[:error]
    end
  end

  should "update a forum for :admin" do
    assert_nothing_raised do
      put :update, {:id => forums(:one).id, :forum => valid_forum_attributes}, {:user => profiles(:admin).id}
      assert_redirected_to :controller => 'forums', :action => 'index' #, :id => forums(:one).to_param
    end
  end
  
  ##
  # :destroy
  
  should "not destroy a forum for guest" do
    assert_nothing_raised do
      assert_no_difference "Forum.count" do
        delete :destroy, {:id => forums(:one).id}
        assert_response 302
        assert_redirected_to :login_path
      end
    end
  end
  
  should "not destroy a forum for :user" do
    assert_nothing_raised do
      assert_no_difference "Forum.count" do
        delete :destroy, {:id => forums(:one).id}, {:user => profiles(:user).id}
        assert_response 302
        assert flash[:error]
      end
    end
  end

  should "destroy a forum for :admin" do
    assert_nothing_raised do
      assert_difference "Forum.count", -1 do
        delete :destroy, {:id => forums(:one).id}, {:user => profiles(:admin).id}
        assert_redirected_to :controller => 'forums', :action => 'index'
      end
    end
  end

end
