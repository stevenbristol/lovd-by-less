##
# ForumPostsController tests
# Author: Les Freeman (lesliefreeman3@gmail.com)
# Created on: 5/16/08
# Updated on: 5/16/08
#


require File.dirname(__FILE__) + '/../test_helper'

class ForumPostsControllerTest < ActionController::TestCase
  
  include ForumsTestHelper
  
  ##
  # :index
  
  should "redirect if index" do
    get :index, {:forum_id => forum_topics(:one).forum.id, 
                   :topic_id => forum_topics(:one).id}
    assert_response 302
    assert_redirected_to forum_path(forum_topics(:one).forum)
  end
  should "redirect if show" do
    get :show, {:forum_id => forum_topics(:one).forum.id, 
                       :topic_id => forum_topics(:one).id, 
                       :id => forum_posts(:one).id}
    assert_response 302
    assert_redirected_to forum_path(forum_topics(:one).forum)
  end
  
  
  ##
  # :new
  
  should "not respond to new" do
    assert !ForumPostsController.new.respond_to?(:new)
  end
  
  ##
  # create

  should "not create a new forum post for guest" do
    assert_nothing_raised do
      assert_no_difference "ForumPost.count" do
        post :create, {:forum_id => forum_topics(:one).forum.id, 
                       :topic_id => forum_topics(:one).id,
                       :forum_post => valid_forum_post_attributes}
        assert_response 302
        assert_redirected_to :login
      end
    end
  end

  should "create a new forum post for :user" do
    assert_nothing_raised do
      assert_difference "ForumPost.count" do
        post :create, {:forum_id => forum_topics(:one).forum.id, 
                       :topic_id => forum_topics(:one).id,
                       :forum_post => valid_forum_post_attributes}, {:user => profiles(:user).id}
        assert_redirected_to forum_topic_url(forum_topics(:one).forum, forum_topics(:one))+"\##{assigns(:post).dom_id}"
      end
    end
  end

  should "create a new forum post for :admin" do
    assert_nothing_raised do
      assert_difference "ForumPost.count" do
        post :create, {:forum_id => forum_topics(:one).forum.id, 
                       :topic_id => forum_topics(:one).id,
                       :forum_post => valid_forum_post_attributes}, {:user => profiles(:admin).id}
        
        assert_redirected_to forum_topic_url(forum_topics(:one).forum, forum_topics(:one))+"\##{assigns(:post).dom_id}"
      end
    end
  end
  
  should "create a new forum post for :admin, js" do
    assert_nothing_raised do
      assert_difference "ForumPost.count" do
        post :create, {:format=>'js', :forum_id => forum_topics(:one).forum.id, 
                       :topic_id => forum_topics(:one).id,
                       :forum_post => valid_forum_post_attributes}, {:user => profiles(:admin).id}
         assert_response 200
      end
    end
  end
  
  
  should "create a new forum post for :admin, xml" do
    assert_nothing_raised do
      assert_difference "ForumPost.count" do
        post :create, {:format=>'xml', :forum_id => forum_topics(:one).forum.id, 
                       :topic_id => forum_topics(:one).id,
                       :forum_post => valid_forum_post_attributes}, {:user => profiles(:admin).id}
         assert_response 200
      end
    end
  end
  
  ##
  # :edit

  should "not get edit for guest" do
    assert_nothing_raised do
      get :edit, {:forum_id => forum_topics(:one).forum.id, 
                  :topic_id => forum_topics(:one).id,
                  :id => forum_topics(:one).id}
      assert_response 302
      assert_redirected_to :login
    end
  end

  should "not get edit for :user" do
    assert_nothing_raised do
      get :edit, {:forum_id => forum_topics(:one).forum.id, 
                  :topic_id => forum_topics(:one).id,
                  :id => forum_topics(:one).id}, {:user => profiles(:user).id}
      assert_response 302
      assert flash[:error]
    end
  end

  should "get edit for :admin" do
    assert_nothing_raised do
      get :edit, {:forum_id => forum_topics(:one).forum.id, 
                  :topic_id => forum_topics(:one).id,
                  :id => forum_topics(:one).id}, {:user => profiles(:admin).id}
      assert_response 200
      assert_template 'edit'
    end
  end
  
  ##
  # :update

  should "not update a forum post for guest" do
    assert_nothing_raised do
      put :update, {:forum_id => forum_posts(:one).topic.forum.id, 
                    :topic_id => forum_posts(:one).topic.id,
                    :id => forum_posts(:one).id,
                    :forum_post => valid_forum_post_attributes}
      assert_response 302
      assert_redirected_to :login
    end
  end

  should "not update a forum post for :user" do
    assert_nothing_raised do
      put :update, {:forum_id => forum_posts(:one).topic.forum.id, 
                    :topic_id => forum_posts(:one).topic.id,
                    :id => forum_posts(:one).id,
                    :forum_post => valid_forum_post_attributes}, {:user => profiles(:user).id}
      assert_response 302
      assert flash[:error]
    end
  end

  should "update a forum post for :admin" do
    assert_nothing_raised do
      put :update, {:forum_id => forum_posts(:one).topic.forum.id, 
                    :topic_id => forum_posts(:one).topic.id,
                    :id => forum_posts(:one).id,
                    :forum_post => valid_forum_post_attributes}, {:user => profiles(:admin).id}
      assert_redirected_to forum_topic_url(forum_topics(:one).forum, forum_topics(:one))+"\##{assigns(:post).dom_id}"
    end
  end
  
  should "update a forum post for :admin js" do
    assert_nothing_raised do
      put :update, {:format=>'js', :forum_id => forum_posts(:one).topic.forum.id, 
                    :topic_id => forum_posts(:one).topic.id,
                    :id => forum_posts(:one).id,
                    :forum_post => valid_forum_post_attributes}, {:user => profiles(:admin).id}
      assert_response 200
    end
  end
  
  should "not update a forum post for :admin" do
    assert_nothing_raised do
      put :update, {:forum_id => forum_posts(:one).topic.forum.id, 
                    :topic_id => forum_posts(:one).topic.id,
                    :id => forum_posts(:one).id,
                    :forum_post => unvalid_forum_post_attributes}, {:user => profiles(:admin).id}
      assert_response 200
    end
  end
  
  should "not update a forum post for :admin js" do
    assert_nothing_raised do
      put :update, {:format=>'js', :forum_id => forum_posts(:one).topic.forum.id, 
                    :topic_id => forum_posts(:one).topic.id,
                    :id => forum_posts(:one).id,
                    :forum_post => unvalid_forum_post_attributes}, {:user => profiles(:admin).id}
      assert_response 200
    end
  end
    
  should "not update a forum post for :admin xml" do
    assert_nothing_raised do
      put :update, {:format=>'xml', :forum_id => forum_posts(:one).topic.forum.id, 
                    :topic_id => forum_posts(:one).topic.id,
                    :id => forum_posts(:one).id,
                    :forum_post => unvalid_forum_post_attributes}, {:user => profiles(:admin).id}
      assert_response 422
    end
  end
  
  ##
  # :destroy

  should "not destroy a forum post for guest" do
    assert_nothing_raised do
        assert_no_difference "ForumPost.count" do
        delete :destroy, {:forum_id => forum_posts(:one).topic.forum.id, 
                          :topic_id => forum_posts(:one).topic.id,
                          :id => forum_posts(:one).id}
        assert_response 302
        assert_redirected_to :login
      end
    end
  end

  should "not destroy a forum post for :user" do
    assert_nothing_raised do
      assert_no_difference "ForumPost.count" do
        delete :destroy, {:forum_id => forum_posts(:one).topic.forum.id, 
                          :topic_id => forum_posts(:one).topic.id,
                          :id => forum_posts(:one).id}, {:user => profiles(:user).id}
        assert_response 302
        assert flash[:error]
      end
    end
  end

  should "destroy a forum post for :admin" do
    assert_nothing_raised do
      assert_difference "ForumPost.count", -1 do
        delete :destroy, {:forum_id => forum_posts(:one).topic.forum.id, 
                          :topic_id => forum_posts(:one).topic.id,
                          :id => forum_posts(:one).id}, {:user => profiles(:admin).id}
        assert_redirected_to forum_topic_url(forum_topics(:one).forum, forum_topics(:one))
      end
    end
  end
  
  should "destroy a forum post for :admin js" do
    assert_nothing_raised do
      assert_difference "ForumPost.count", -1 do
        delete :destroy, {:format=>'js', :forum_id => forum_posts(:one).topic.forum.id, 
                          :topic_id => forum_posts(:one).topic.id,
                          :id => forum_posts(:one).id}, {:user => profiles(:admin).id}
          assert_response 200
      end
    end
  end
  
end

