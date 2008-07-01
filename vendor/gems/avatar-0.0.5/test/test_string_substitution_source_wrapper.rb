require File.dirname(__FILE__) + '/test_helper.rb'
require 'avatar/source/static_url_source'
require 'avatar/source/wrapper/string_substitution_source_wrapper'

class TestStringSubstitutionSourceWrapper < Test::Unit::TestCase
  
  def setup
    @source = Avatar::Source::StaticUrlSource.new('#{a} and #{b} but not {b}')
    @wrapper = Avatar::Source::Wrapper::StringSubstitutionSourceWrapper.new(@source)
  end
  
  def test_returns_nil_if_underlying_source_returns_nil
    @source.instance_eval { def avatar_url_for(*args); nil; end }
    assert_nil @wrapper.avatar_url_for(:a_person)
  end
  
  def test_avatar_url_nil_when_not_all_variables_replaced
    assert_nil @wrapper.avatar_url_for(:bar, :b => 'ham')
  end
  
  def test_avatar_url_when_all_variables_replaced
    assert_equal 'green eggs and ham but not {b}', @wrapper.avatar_url_for(:bar, :a => 'green eggs', :b => 'ham')
  end
  
end