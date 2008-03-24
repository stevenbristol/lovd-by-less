require File.dirname(__FILE__) + '/../test_helper'

class HomeControllerTest < ActionController::TestCase

  should 'render contact form' do
    assert_nothing_raised do
      get :contact      
      assert_response :success
      assert_template 'contact'
    end
  end


  should 'render home page' do
    assert_nothing_raised do
      get :index
      assert_response :success
      assert_template 'index'
    end
  end


  should 'render terms page' do
    assert_nothing_raised do
      get :terms

      assert_response :success
      assert_template 'terms'
    end
  end

  context 'on POST to :contact' do
    should 'render contact form' do
      assert_nothing_raised do
        post :contact, {:name => 'Bob Smith', :phone => '123.123.1234', :email => 'bs@example.com', :message => 'wow'}

        assert_response :redirect
        assert_redirected_to contact_url
        assert_equal "Thank you for your message.  A member of our team will respond to you shortly.", flash[:notice]
      end
    end
  end
end