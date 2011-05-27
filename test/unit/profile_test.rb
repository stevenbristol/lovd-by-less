require 'test_helper'

class ProfileTest < ActiveSupport::TestCase

  context 'A Profile instance' do
    should belong_to :user
    should have_many :friendships
    should have_many :friends
    should have_many :follower_friends
    should have_many :following_friends
    should have_many :followers
    should have_many :followings
    should have_many :comments
    should have_many :blogs
    should_not allow_mass_assignment_of :is_active

    should ensure_length_of(:email).
        is_at_least(3).
        is_at_most(100).
        with_short_message('does not look like an email address.').
        with_long_message('does not look like an email address.')
        
    should allow_value('a@x.com').for(:email).with_message('does not look like an email address.')
    should allow_value('de.veloper@example.com').for(:email).with_message('does not look like an email address.')

    should_not allow_value('example.com').for(:email).with_message('does not look like an email address.')
    should_not allow_value('@example.com').for(:email).with_message('does not look like an email address.')
    should_not allow_value('developer@example').for(:email).with_message('does not look like an email address.')
    should_not allow_value('developer').for(:email).with_message('does not look like an email address.')

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
