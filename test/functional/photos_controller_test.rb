require File.dirname(__FILE__) + '/../test_helper'

class PhotosControllerTest < ActionController::TestCase

  VALID_PHOTO = {
    :image => ActionController::TestUploadedFile.new(File.join(RAILS_ROOT, 'public/images/avatar_default_big.png'), 'image/png')
  }

  context 'on GET to :index while not logged in' do
    setup do
      get :index, {:profile_id => profiles(:user).id}
    end

    should_assign_to :profile
    should_assign_to :photos
    should_respond_with :success
    should_render_template :index
    should_not_set_the_flash
    should "not render the upload form" do
      assert_no_tag :tag => 'form', :attributes => {:action => profile_photos_path(assigns(:profile))}
    end
  end


  context 'on GET to :index while logged in as :owner' do
    setup do
        get :index, {:profile_id => profiles(:user).id}, {:user => users(:user).id}
    end

    should_assign_to :profile
    should_assign_to :photos
    should_respond_with :success
    should_render_template :index
    should_not_set_the_flash
    should "render the upload form" do
      assert_tag :tag => 'form', :attributes => {:action => profile_photos_path(assigns(:profile))}
    end
  end

  context 'on GET to :index while logged in as :user' do
    setup do
        get :index, {:profile_id => profiles(:user).id}, {:user => users(:user2).id}
    end

    should_assign_to :profile
    should_assign_to :photos
    should_respond_with :success
    should_render_template :index
    should_not_set_the_flash
    should "not render the upload form" do
      assert_no_tag :tag => 'form', :attributes => {:action => profile_photos_path(assigns(:profile))}
    end
  end

  context 'on GET to :show' do
    setup do
      get :show, {:profile_id => profiles(:user).id, :id => photos(:first)}
    end

    should_respond_with :redirect
    should_redirect_to 'profile_photos_path(profiles(:user))'
    should_not_set_the_flash
  end


  context 'on DELETE to :destroy while logged in as :owner' do
    setup do
      assert_difference "Photo.count", -1 do
        delete :destroy, {:profile_id => profiles(:user).id, :id => photos(:first)}, {:user => profiles(:user).id}
      end
    end

    should_respond_with :redirect
    should_redirect_to 'profile_photos_path(profiles(:user))'
    should_set_the_flash_to 'Photo was deleted.'
  end

  context 'on DELETE to :destroy while logged in as :user' do
    setup do
      assert_no_difference "Photo.count" do
        delete :destroy, {:profile_id => profiles(:user).id, :id => photos(:first)}, {:user => profiles(:user2).id}
      end
    end

    should_respond_with :redirect
    should_redirect_to 'home_path'
    should_set_the_flash_to 'It looks like you don\'t have permission to view that page.'
  end

  context 'on DELETE to :destroy while logged not in' do
    setup do
      assert_no_difference "Photo.count" do
        delete :destroy, {:profile_id => profiles(:user).id, :id => photos(:first)}
      end
    end

    should_respond_with :redirect
    should_redirect_to 'home_path'
    should_set_the_flash_to 'It looks like you don\'t have permission to view that page.'
  end



  context 'on POST to :create with good data while logged in as :owner' do
    setup do
      assert_difference "Photo.count" do
        post :create, {:profile_id => profiles(:user).id, :photo => VALID_PHOTO}, {:user => profiles(:user).id}
      end
    end

    should_respond_with :redirect
    should_redirect_to 'profile_photos_path(profiles(:user))'
    should_set_the_flash_to 'Photo successfully uploaded.'
  end

  context 'on POST to :create with bad data while logged in as :owner' do
    setup do
      assert_no_difference "Photo.count" do
        post :create, {:profile_id => profiles(:user).id, :photo => {:image => ''}}, {:user => profiles(:user).id}
      end
    end

    should_respond_with :success
    should_render_template 'index'
  end

  context 'on POST to :create while logged in as :user' do
    setup do
      assert_no_difference "Photo.count" do
        post :create, {:profile_id => profiles(:user).id, :id => photos(:first)}, {:user => profiles(:user2).id}
      end
    end

    should_respond_with :redirect
    should_redirect_to 'home_path'
  end

  context 'on POST to :create while logged not in' do
    setup do
      assert_no_difference "Photo.count" do
        post :create, {:profile_id => profiles(:user).id, :id => photos(:first)}
      end
    end

    should_respond_with :redirect
    should_redirect_to 'home_path'
  end


end
