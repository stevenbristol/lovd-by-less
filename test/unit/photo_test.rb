require File.dirname(__FILE__) + '/../test_helper'

class PhotoTest < Test::Unit::TestCase
  fixtures :users, :photos
  
  context "A Photo instance" do
    
    should_belong_to :profile
    should_require_attributes :image, :profile_id
  end
end