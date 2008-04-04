require File.dirname(__FILE__) + '/../test_helper'

class ProfileTest < ActiveSupport::TestCase

  context 'A Profile instance' do
    should_belong_to :user
    should_have_many :friendships
    should_have_many :friends,   :through     => :friendships
    should_have_many :follower_friends
    should_have_many :following_friends
    should_have_many :followers, :through => :follower_friends
    should_have_many :followings, :through => :following_friends
    should_have_many :comments, :blogs
    should_protect_attributes :is_active

    should_ensure_length_in_range :email, 3..100, :short_message => 'does not look like an email address.', :long_message => 'does not look like an email address.'
    should_allow_values_for :email, 'a@x.com', 'de.veloper@example.com', :message => 'does not look like an email address.'
    should_not_allow_values_for :email, 'example.com', '@example.com', 'developer@example', 'developer', :message => 'does not look like an email address.'
  end




  context 'profiles(:user)' do
    should 'be friends with profiles(:user2)' do
      assert profiles(:user).friend_of?( profiles(:user2) )
      assert profiles(:user2).friend_of?( profiles(:user) )
    end

    should 'be following profiles(:user3)' do
      assert profiles(:user).following?( profiles(:user3) )
      assert profiles(:user3).followed_by?( profiles(:user) )
    end
  end



  should "prefix with http" do
    p = profiles(:user)
    assert p.website.nil?
    assert p.website = 'lovdbyless.com'
    assert p.save
    assert_equal 'http://lovdbyless.com', p.reload.website
  end


  should "prefix with http4" do
    p = profiles(:user)
    assert p.website.nil?
    assert p.website = ''
    assert p.save
    assert_equal '', p.reload.website
  end


  should "prefix with http2" do
    p = profiles(:user)
    assert p.blog.nil?
    assert p.blog = 'lovdbyless.com'
    assert p.save
    assert_equal 'http://lovdbyless.com', p.reload.blog
  end


  should "prefix with http3" do
    p = profiles(:user)
    assert p.flickr.nil?
    assert p.flickr = 'lovdbyless.com'
    assert p.save
    assert_equal 'http://lovdbyless.com', p.reload.flickr
  end





  should "have wall with user2" do
    assert profiles(:user).has_wall_with(profiles(:user2))
  end

  should "not have wall with user3" do
    assert !profiles(:user).has_wall_with(profiles(:user3))
  end

  def test_associations
    _test_associations
  end

end
