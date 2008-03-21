require File.dirname(__FILE__) + '/../test_helper'

class MessageTest < Test::Unit::TestCase
  fixtures :messages, :users
  
  
#  should_require_attributes :subject, :body

  
  def test_associations
    _test_associations
  end
end
