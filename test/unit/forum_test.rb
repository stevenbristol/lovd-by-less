##
# Forums tests
# Author: Les Freeman (lesliefreeman3@gmail.com)
# Created on: 5/16/08
# Updated on: 5/16/08
# 

require File.dirname(__FILE__) + '/../test_helper'

class ForumTest < ActiveSupport::TestCase
  
  context "A Forum instance" do
    
    should_require_attributes :name
    should_have_many :topics, :posts
  
  end
  
end
