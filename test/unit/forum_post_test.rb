##
# ForumPost test
# Author: Les Freeman (lesliefreeman3@gmail.com)
# Created on: 5/16/08
# Updated on: 5/16/08
#

require File.dirname(__FILE__) + '/../test_helper'

class ForumPostTest < ActiveSupport::TestCase
  
  should_require_attributes :body, :owner_id
  
  should_belong_to :owner
  should_belong_to :topic
  
end
