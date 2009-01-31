require File.dirname(__FILE__) + '/../test_helper'

class ProfilesControllerTest < ActionController::TestCase

  context 'on POST to :search' do
    setup do
      Profile.stubs(:search).returns(ThinkingSphinx::Collection.new(1, 1, 1, 1))
      post :search, {:q => 'user'}
    end

    should_assign_to :results
    should_respond_with :success
    should_render_template :search
  end

  context 'on GET to :index' do
    setup do
      Profile.stubs(:search).returns(ThinkingSphinx::Collection.new(1, 1, 1, 1))
      get :index
    end

    should_assign_to :results
    should_respond_with :success
    should_render_template :search
  end

  context 'on GET to :show while not logged in' do
    setup do
      get :show, {:id => profiles(:user).id}
      assert_match "Sign-up to Follow", @response.body
    end

    should_assign_to :user
    should_assign_to :profile
    should_respond_with :success
    should_render_template :show
    should_not_set_the_flash
  end

  context 'on GET to :show.rss while not logged in' do
    setup do
      get :show, {:id => profiles(:user).id, :format=>'rss'}
      assert_match "<rss version=\"2.0\">\n  <channel>\n    <title>#{SITE_NAME} Activity Feed</title>", @response.body
    end

    should_assign_to :user
    should_assign_to :profile
    should_respond_with :success
    should_render_template :show
    should_not_set_the_flash
  end

  context 'on GET to :edit while not logged in' do
    setup do
      get :edit, {:id => profiles(:user).id}
    end

    should_not_assign_to :user
    should_respond_with :redirect
    should_redirect_to 'login_path'
    should_not_set_the_flash
  end


  context 'on GET to :show while logged in' do
    setup do
        get :show, {:id => profiles(:user).id}, {:user => profiles(:user).id}
    end

    should_assign_to :user
    should_assign_to :profile
    should_respond_with :success
    should_render_template :show
    should_not_set_the_flash
  end

  context 'on GET to :show while logged in as :user3' do
    setup do
      get :show, {:id => profiles(:user).id}, {:user => profiles(:user3).id}
      assert profiles(:user3).followed_by?(profiles(:user))
      assert_match "Be Friends", @response.body
    end

    should_assign_to :user
    should_assign_to :profile
    should_respond_with :success
    should_render_template :show
    should_not_set_the_flash
  end

  context 'on GET to :show while logged in as :user2' do
    setup do
      get :show, {:id => profiles(:user3).id}, {:user => profiles(:user2).id}
      assert_match "Start Following", @response.body
    end

    should_assign_to :user
    should_assign_to :profile
    should_respond_with :success
    should_render_template :show
    should_not_set_the_flash
  end


  context 'on GET to :edit while logged in' do
    setup do
        get :edit, {:id => profiles(:user).id}, {:user => profiles(:user).id}
      end

    should_assign_to :user
    should_assign_to :profile
    should_respond_with :success
    should_render_template :edit
    should_render_a_form
    should_not_set_the_flash
  end  
  
  context 'rendering an avatar' do
    
    should 'use the user\'s icon if it exists' do
      p =  profiles(:user)
      p.icon = File.new(File.join(RAILS_ROOT, ['test', 'public','images','user.png']))
      p.save!
      #raise (p.send :icon_state).inspect
      assert_not_nil p.icon
      get :show, {:id => p.id, :public_view => true}, {:user => p.id}
      assert_tag :img, :attributes => { :src => /\/system\/profile\/icon\/\d*\/big\/user.png/ }
    end
    
    should 'use gravatar otherwise' do
      p =  profiles(:user2)
      assert_nil p.icon
      get :show, {:id => p.id}, {:user => p.id, :public_view => true}
      assert_tag :img, :attributes => {:src => /www\.gravatar\.com/}
    end
    
    should 'send the app\'s internal default as the default to gravatar' do
      p =  profiles(:user2)
      assert_nil p.icon
      get :show, {:id => p.id}, {:user => p.id, :public_view => true}
      assert_tag :img, :attributes => { :src => /http...www.gravatar.com\/avatar\/[0-9a-f]+\?size\=50&amp;default\=http...test\.host\/images\/avatar_default_small\.png/ }
    end
  end


  context 'on POST to :delete_icon' do
    should 'delete the icon from the users profile' do
      assert_not_nil profiles(:user).icon
      post :delete_icon, {:id => profiles(:user).id, :format => 'js'}, {:user => profiles(:user).id}
      assert_response :success
      assert_nil assigns(:p).reload.icon
    end
  end


  context 'on POST to :update' do
    should 'update a user\'s profile with good data when logged in' do
      assert_equal 'De', profiles(:user).first_name

        post :update, {:id => profiles(:user).id, :user => {:email => 'user@example.com'}, :profile => {:first_name => 'Bob'}, :switch => 'name'}, {:user => profiles(:user).id}

      assert_response :redirect
      assert_redirected_to edit_profile_path(profiles(:user).reload)
      assert_equal 'Settings have been saved.', flash[:notice]

      assert_equal 'Bob', profiles(:user).reload.first_name
    end

    should 'not update a user\'s profile with bad data when logged in' do
        post :update, {:id => profiles(:user).id, :profile => {:email => ''}, :switch => 'name'}, {:user => profiles(:user).id}

      assert_response :success
      assert_template 'edit'
      assert_not_nil assigns(:profile).errors
    end

    should 'not update a user\'s profile without a switch' do
      assert_equal 'De', profiles(:user).first_name

        post :update, {:id => profiles(:user).id, :user => {:email => 'user@example.com'}, :profile => {:first_name => 'Bob'}}, {:user => profiles(:user).id}

      assert_equal 'De', profiles(:user).first_name

      assert_response :success
    end

    should 'update a user\'s password with good data when logged in' do
      pass = users(:user).crypted_password

        post :update, {:id => profiles(:user).id, :verify_password => 'test', :new_password => '1234', :confirm_password => '1234', :switch => 'password'}, {:user => profiles(:user).id}

      assert_response :redirect
      assert_redirected_to edit_profile_path(profiles(:user))
      assert_equal 'Password has been changed.', flash[:notice]

      assert_not_equal pass, assigns(:u).reload.crypted_password
    end

    should 'not update a user\'s password with bad data when logged in' do
      pass = users(:user).crypted_password

      post :update, {:id => profiles(:user).id, :verify_password => 'test', :new_password => '4321', :confirm_password => '1234', :switch => 'password'}, {:user => profiles(:user).id}

      assert_response :success
      assert_template 'edit'
      assert_not_nil assigns(:user).errors
    end

  end


  should "delete" do
    assert_difference 'User.count', -1 do
      assert users(:user)
      delete :destroy, {:id=>users(:user).id}, {:user, users(:user).id}
      assert_response 200
      assert_nil User.find_by_id(users(:user).id)
    end
  end


end
