require File.dirname(__FILE__) + '/../test_helper'

class FriendTest < ActiveSupport::TestCase
  # 
  # context "A Friend instance" do
  #   should_belong_to :inviter
  #   should_belong_to :invited
  # end
  # 
  # 
  # context "profiles(:user3)" do
  #   should "be able to start and stop following profiles(:user2)" do
  #     u3 = profiles(:user3) and u2 = profiles(:user2)
  #     assert !u3.following?(u2)
  #     assert_difference Friend, :count do
  #       Friend.start_following(u3, u2)
  #       u2.reload and u3.reload
  #       assert u3.following?(u2)
  #     end
  #     
  #     assert_difference Friend, :count, -1 do
  #       Friend.stop_following(u3, u2)
  #       u2.reload and u3.reload
  #       assert !u3.following?(u2)
  #     end
  #   end
  #   
  #   should "be able to be friends and stop being friends with profiles(:user)" do
  #     u3 = profiles(:user3) and u = profiles(:user)
  #     assert !u3.friend_of?(u)
  #     assert_difference Friend, :count do
  #       Friend.make_friends(u3, u)
  #       u.reload and u3.reload
  #       assert u3.friend_of?(u)
  #     end
  #     
  #     assert_difference Friend, :count, -1 do
  #       Friend.stop_being_friends(u3, u)
  #       u.reload and u3.reload
  #       assert !u3.friend_of?(u)
  #     end
  #   end
  # end
  # 
  # 
  # 
  # def test_associations
  #   _test_associations
  # end
  
  
  
  should "not create an association with the same user" do
    Friend.destroy_all    
    assert !Friend.add_follower(profiles(:user), profiles(:user))
    assert_equal 0, Friend.count
  end
  
  
  
  should "have friends" do
    assert profiles(:user).friends.any?{|f| f.id == profiles(:user2).id}
    assert !profiles(:user).friends.any?{|f| f.id == profiles(:user3).id}
    assert profiles(:user).followings.any?{|f| f.id == profiles(:user3).id}
    assert profiles(:user2).friends.any?{|f| f.id == profiles(:user).id}
    assert !profiles(:user3).friends.any?{|f| f.id == profiles(:user).id}
    assert profiles(:user3).followers.any?{|f| f.id == profiles(:user).id}
  end
  
  
  should "create a new fan assocication" do
    Friend.destroy_all
    
    assert Friend.add_follower(profiles(:user), profiles(:user2))
    assert_equal 1, Friend.count
    assert !profiles(:user).reload.friend_of?(profiles(:user2).reload)
    assert profiles(:user).following?(profiles(:user2))
    assert profiles(:user2).followed_by?(profiles(:user))
  end
  
  
  should "not find an following to turn into a friendship so just makes a fan" do
    Friend.destroy_all
    assert Friend.make_friends(profiles(:user), profiles(:user2))
    assert_equal 1, Friend.count
    assert !profiles(:user).reload.friend_of?(profiles(:user2).reload)
    assert profiles(:user).following?(profiles(:user2))
    assert profiles(:user2).followed_by?(profiles(:user))
  end


  should "turn a following into a friendship" do
    Friend.destroy_all
    assert Friend.add_follower(profiles(:user), profiles(:user2))
    assert_equal 1, Friend.count

    assert Friend.make_friends(profiles(:user2), profiles(:user))
    assert_equal 2, Friend.count
    
    profiles(:user).reload
    profiles(:user2).reload
    
    assert profiles(:user).friend_of?(profiles(:user2))
    assert profiles(:user2).friend_of?(profiles(:user))
  end
  
  
  should "turn a following into a friendship2" do
    Friend.destroy_all
    assert Friend.add_follower(profiles(:user), profiles(:user2))
    assert_equal 1, Friend.count

    assert Friend.make_friends(profiles(:user), profiles(:user2))
    assert_equal 2, Friend.count
    
    profiles(:user).reload
    profiles(:user2).reload
    
    assert profiles(:user).friend_of?(profiles(:user2))
    assert profiles(:user2).friend_of?(profiles(:user))
  end
  
  
  should "not find a friendship so can't stop being friends" do
    Friend.destroy_all
    assert !Friend.stop_being_friends(profiles(:user), profiles(:user2))
  end
  
  
  should "stop being friends and not be a fan" do
    Friend.destroy_all
    assert Friend.add_follower(profiles(:user), profiles(:user2))
    assert Friend.make_friends(profiles(:user), profiles(:user2))
    assert_equal 2, Friend.count
    
    profiles(:user).reload
    profiles(:user2).reload
    
    assert Friend.stop_being_friends(profiles(:user), profiles(:user2))
    profiles(:user).reload
    profiles(:user2).reload
    
    assert !profiles(:user).friend_of?(profiles(:user2))
    assert !profiles(:user).following?(profiles(:user2))
    assert profiles(:user).followed_by?(profiles(:user2))
    
    assert !profiles(:user2).friend_of?(profiles(:user))
    assert profiles(:user2).following?(profiles(:user))
    assert !profiles(:user2).followed_by?(profiles(:user))
    
  end
  
  
  
  should "not find a friendship so can't reset" do
    Friend.destroy_all
    assert_no_difference "Friend.count" do
      assert Friend.reset(profiles(:user), profiles(:user2))
    end
  end
  
  
  
  should "reset friendship" do
    Friend.destroy_all
    assert Friend.add_follower(profiles(:user), profiles(:user2))
    assert Friend.make_friends(profiles(:user), profiles(:user2))
    assert_equal 2, Friend.count
    
    profiles(:user).reload
    profiles(:user2).reload
    
    assert Friend.reset(profiles(:user), profiles(:user2))
    assert_equal 1, Friend.count
    profiles(:user).reload
    profiles(:user2).reload
    
    assert !profiles(:user).friend_of?(profiles(:user2))
    assert !profiles(:user).following?(profiles(:user2))
    assert profiles(:user).followed_by?(profiles(:user2))
    assert !profiles(:user).following?(profiles(:user2))
    
    assert !profiles(:user2).friend_of?(profiles(:user))
    assert profiles(:user2).following?(profiles(:user))
    assert !profiles(:user2).followed_by?(profiles(:user))
    assert profiles(:user2).following?(profiles(:user))
    
    
  end
end