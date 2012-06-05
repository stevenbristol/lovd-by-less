require 'test_helper'

class PhotoTest < ActiveSupport::TestCase
  
  context "A Photo instance" do
    
    should belong_to :profile
    should validate_presence_of :profile_id
  end
end