require File.dirname(__FILE__) + '/../test_helper'

class UserTest < ActiveSupport::TestCase

  VALID_USER = {:password=>'123456', :password_confirmation=>'123456', :login=>'valid_user', :email=>'valid_user@example.com', :terms_of_service => '1'}



  context 'A User instance' do
    should_require_attributes :login, :password, :password_confirmation
    should_require_unique_attributes :login

    should_ensure_length_in_range :login, 3..40
    should_ensure_length_in_range :password, 4..40
    should_protect_attributes :is_admin, :can_send_messages

    should 'be able to change their password' do
      assert p = users(:user).crypted_password
      assert u2 = User.find(users(:user).id)
      assert u2.change_password('test', 'asdfg', 'asdfg')
      assert u2.valid?
      assert_not_equal(p, u2.crypted_password)
    end

    should 'require the correct current password in order to change password' do
      assert p = users(:user).crypted_password
      assert u2 = User.find(users(:user).id)
      assert !u2.change_password('tedst', 'asdfg', 'asdfg')
      assert u2.valid?
      assert_equal(p, u2.crypted_password)
    end

    should 'require a matching password confirmation to change password' do
      assert p = users(:user).crypted_password
      assert u2 = User.find(users(:user).id)
      assert !u2.change_password('test', 'asdfg', 'asdfgd')
      assert u2.valid?
      assert_equal(p, u2.crypted_password)
    end

    should 'reset password if forgotten' do
      p1 = users(:user).crypted_password
      assert users(:user).forgot_password
      assert_not_equal p1, users(:user).reload.crypted_password
    end

    should 'leave profile intact after a destroy' do
      u = users(:user)
      assert_no_difference "Profile.count" do
        assert_difference "User.count", -1 do
          u.destroy
        end
      end
    end
  end


  context 'A new User instance' do
    should 'be valid if the password and password confirmation matches' do
      assert u = User.new(VALID_USER)
      assert u.valid?
    end

    should 'be invalid if password confirmation does not match the password' do
      assert u = User.new(VALID_USER.merge(:password => '12345'))
      assert !u.valid?
    end

    should 'not be created without terms' do
      assert_no_difference "User.count" do
        User.create({
          :login => 'lquire',
          :email => 'lquire@example.com',
          :password => 'lquire',
          :password_confirmation => 'lquire',
          :terms_of_service => '0'
          })
      end
    end

    should 'be created when given valid options' do
      assert_difference "User.count" do
        assert u = User.create(VALID_USER)
        assert !u.new_record?, u.errors.full_messages.to_sentence
        assert u.profile
        assert u.profile.is_active
      end
    end
  end

  context 'users(:user)' do
    should 'be able to reset their password' do
      users(:user).update_attributes(:password => 'new password', :password_confirmation => 'new password')
      assert_equal users(:user), User.authenticate('user', 'new password')
    end

    should 'not rehash their password' do
      users(:user).update_attributes(:login => 'user8')
      assert_equal users(:user), User.authenticate('user8', 'test')
    end

    should 'be able to authenticate' do
      assert_equal users(:user), User.authenticate('user', 'test')
    end

    should 'be remembered' do
      users(:user).remember_me
      assert users(:user).remember_token?
      assert_not_nil users(:user).remember_token
      assert_not_nil users(:user).remember_token_expires_at
    end
  end
  #
  #   def test_should_not_authenticate_user_inactive
  #     assert !User.authenticate('inactive', 'test')
  #   end
  #
  #
  #
  #
  #   def test_full_name
  #     assert u = users(:system)
  #     assert_equal "system", u.full_name
  #
  #     assert u2 = users(:second)
  #     assert_equal 'hello', u2.full_name
  #
  #     assert u3 = users(:quentin)
  #     assert_equal "quentin", u3.full_name
  #   end
  #
  #
  #
    should "not be able to mail" do
      assert !users(:inactive).can_mail?( users(:user))
      assert users(:user).can_mail?( users(:inactive))
      assert !users(:cant_message).can_mail?( users(:user))
      assert users(:user).can_mail?( users(:cant_message))
    end
  #
  #   def test_associations
  #     _test_associations
  #   end
end
