# ForumPost test
# Author: Les Freeman (lesliefreeman3@gmail.com)
# Created on: 5/16/08
# Updated on: 5/16/08
#

require 'test_helper'

class ForumPostTest < ActiveSupport::TestCase
  
  should validate_presence_of :body
  should validate_presence_of :owner_id
  
  should belong_to :owner
  should belong_to :topic
  
end
