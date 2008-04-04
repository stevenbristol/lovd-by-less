require File.dirname(__FILE__) + '/../test_helper'

class FriendsControllerTest < ActionController::TestCase

  should 'render index page not logged in' do
    assert_nothing_raised do
      get :index, :profile_id => profiles(:user).id
      assert_response :success
      assert_template 'index'
    end
  end



  should 'render my index page' do
    assert_nothing_raised do
      get :index, {:profile_id => profiles(:user).id}, {:user => users(:user).id}
      assert_response :success
      assert_template 'index'
    end
  end



  should "make a fan" do
    Friend.destroy_all

    post :create, {:profile_id=>profiles(:user).id, :id => profiles(:user2).id, :format=>'js'}, {:user=>profiles(:user).id}
    assert_response :success

    profiles(:user).reload
    profiles(:user2).reload

    assert !profiles(:user).friend_of?(profiles(:user2))
    assert profiles(:user).following?(profiles(:user2))
    assert profiles(:user2).followed_by?(profiles(:user))
  end


  should "make a friendship" do
    Friend.destroy_all
    Friend.make_friends profiles(:user), profiles(:user2)
    post :create, {:profile_id=>profiles(:user).id, :id=>profiles(:user2).id, :format=>'js'}, {:user=>profiles(:user).id}
    assert_response :success

    profiles(:user).reload
    profiles(:user2).reload

    assert profiles(:user).friend_of?(profiles(:user2))
    assert !profiles(:user).followed_by?(profiles(:user2))
    assert profiles(:user2).friend_of?(profiles(:user))
    assert !profiles(:user2).followed_by?(profiles(:user))
  end

  should "error while trying to make an invalid friendship" do
    Friend.destroy_all
    post :create, {:profile_id=>profiles(:user).id, :id=>profiles(:user).id, :format=>'js'}, {:user=>profiles(:user).id}
    assert_response :success

    profiles(:user).reload
    profiles(:user2).reload
  end

  should 'stop following' do
    Friend.destroy_all
    Friend.make_friends profiles(:user), profiles(:user2)
    delete :destroy, {:profile_id=>profiles(:user).id, :id=>profiles(:user2).id, :format=>'js'}, {:user=>profiles(:user).id}
    assert_response :success

    profiles(:user).reload
    profiles(:user2).reload

    assert !profiles(:user).following?(profiles(:user2))
  end

  should 'stop being friends' do
    Friend.destroy_all
    Friend.make_friends profiles(:user), profiles(:user2)
    Friend.make_friends profiles(:user2), profiles(:user)
    delete :destroy, {:profile_id=>profiles(:user).id, :id=>profiles(:user2).id, :format=>'js'}, {:user=>profiles(:user).id}
    assert_response :success

    profiles(:user).reload
    profiles(:user2).reload

    assert !profiles(:user).friend_of?(profiles(:user2))
    assert !profiles(:user).following?(profiles(:user2))
    assert profiles(:user).followed_by?(profiles(:user2))
  end
end