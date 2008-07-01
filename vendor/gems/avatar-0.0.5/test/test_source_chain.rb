require File.dirname(__FILE__) + '/test_helper.rb'
require 'avatar/source/abstract_source'
require 'avatar/source/static_url_source'
require 'avatar/source/source_chain'

class FooSource
  include Avatar::Source::AbstractSource
  def avatar_url_for(person, options = {})
    'foobar' if person.to_s == 'foobar'
  end
end

class TestSourceChain < Test::Unit::TestCase
  
  def setup
    @source = Avatar::Source::SourceChain.new
  end
  
  def test_nil_when_person_is_nil
    assert_nil @source.avatar_url_for(nil)
  end
  
  def test_nil_when_person_is_not_nil
    assert_nil @source.avatar_url_for(:scottish_terrier)
  end
  
  def test_avatar_url_for
    @source << FooSource.new
    assert_equal 'foobar', @source.avatar_url_for(:foobar)
    assert_nil @source.avatar_url_for(:fazbot)
    
    @source << Avatar::Source::StaticUrlSource.new('default_avatar.png')
    assert_equal 'foobar', @source.avatar_url_for(:foobar)
    assert_equal 'default_avatar.png', @source.avatar_url_for(:fazbot)
  end
  
  def test_clear!
    @source << FooSource.new
    @source << Avatar::Source::StaticUrlSource.new('eeek_a_mouse!')
    @source.clear!
    assert @source.empty?
  end
  
end