require File.dirname(__FILE__) + '/test_helper.rb'
require 'avatar/source/nil_source'

class TestNilSource < Test::Unit::TestCase
  
  def setup
    @source = Avatar::Source::NilSource.new
  end
  
  def test_nil_when_person_is_nil
    assert_nil @source.avatar_url_for(nil)
  end
  
  def test_nil_when_person_is_not_nil
    assert_nil @source.avatar_url_for(49329)
  end
  
end