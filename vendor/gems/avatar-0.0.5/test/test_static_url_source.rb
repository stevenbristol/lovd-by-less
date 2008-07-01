require File.dirname(__FILE__) + '/test_helper.rb'
require 'avatar/source/static_url_source'

class TestStaticUrlSource < Test::Unit::TestCase
  
  def setup
    @source = Avatar::Source::StaticUrlSource.new('foobar')
  end
  
  def test_nil_when_person_is_nil
    assert_nil @source.avatar_url_for(nil)
  end
  
  def test_not_nil_when_person_is_not_nil
    assert_equal 'foobar', @source.avatar_url_for(7)
  end
  
end