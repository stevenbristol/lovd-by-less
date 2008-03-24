require File.dirname(__FILE__) + '/../test_helper'

class MessagesControllerTest < ActionController::TestCase

  should "get the index" do
    assert_nothing_raised do
      get :index, {}, {:user => profiles(:user).id}
      assert_response 200
      assert_template 'index'
    end
  end

  should "get the index as :admin" do
    assert_nothing_raised do
      get :index, {}, {:user => profiles(:admin).id}
      assert_response 200
      assert_template 'index'
    end
  end


  should "not get the index (security redirect)" do
    assert_nothing_raised do
      get :index
      assert_response 302
      assert_redirected_to login_path
    end
  end


  should "get the show message page" do
    assert_nothing_raised do
      get :show, {:id => messages(:user_to_user2).id}, {:user => profiles(:user).id}
      assert_response 200
      assert_template 'show'
    end
  end


  should "get the show message page (security redirect)" do
    assert_nothing_raised do
      get :show, {:id => messages(:user_to_user2)}
      assert_response 302
      assert_redirected_to login_path
    end
  end


  should "get sent messages" do
    assert_nothing_raised do
      get :sent, {}, {:user => profiles(:user).id}
      assert_response 200
      assert_template 'sent'
    end
  end


  should "not get sent messages" do
    assert_nothing_raised do
      get :sent
      assert_response 302
      assert_redirected_to login_path
    end
  end


  should "create a new message" do
    assert_nothing_raised do
      assert_difference "Message.count" do
        post :create, {:profile_id => profiles(:user2).id, :message => {:subject => 'test', :body => 'message', :receiver_id => profiles(:user2).id}}, {:user => profiles(:user).id}
        assert_response 200
      end
    end
  end


  should "not create a new message (redirect to login)" do
    assert_nothing_raised do
      assert_no_difference "Message.count" do
        post :create, {:profile_id => profiles(:user2).id, :message => {:subject => 'test', :body => 'message', :receiver_id => '2'}}
        assert_response 302
        assert_redirected_to login_path
      end
    end
  end


  should "not create a new message (missing data)" do
    assert_nothing_raised do
      assert_no_difference "Message.count" do
        post :create, {:profile_id => profiles(:user2).id, :message => {:subject => '', :body => ''}}, {:user => profiles(:user).id}
        assert_response 200
      end
    end
  end


  should "not create a new message (no can_send)" do
    assert_nothing_raised do
      assert_no_difference "Message.count" do
        post :create, {:profile_id => profiles(:user2).id, :message => {:subject => '', :body => ''}}, {:user => profiles(:cant_message).id}
        assert_response 200
        assert_match "Cuz you sux", @response.body
      end
    end
  end

end