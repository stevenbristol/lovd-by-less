require File.dirname(__FILE__) + '/test_helper.rb'
require 'avatar/view/abstract_view_support'
require 'avatar/source/static_url_source'

class TestAbstractViewSupport < Test::Unit::TestCase

  def setup
    Avatar::source = Avatar::Source::StaticUrlSource.new('golfing.png')
    @view_class = Class.new
    @view_class.send :include, Avatar::View::AbstractViewSupport
    @view = @view_class.new
  end
  
  def test_includes_basic_view_support
    assert @view.kind_of?(Avatar::View::AbstractViewSupport)
  end
  
  def test_avatar_url_for_with_no_arguments
    assert_equal 'golfing.png', @view.avatar_url_for(:a_person)
  end
  
end
