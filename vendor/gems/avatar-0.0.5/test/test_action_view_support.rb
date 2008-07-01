require File.dirname(__FILE__) + '/test_helper.rb'
require 'avatar/view/action_view_support'
require 'avatar/source/static_url_source'

class TestActionViewSupport < Test::Unit::TestCase

  def setup
    Avatar::source = Avatar::Source::StaticUrlSource.new('i-am-oscar-wilde.png')
    @view_class = Class.new(ActionView::Base)
    @view_class.send :include, Avatar::View::ActionViewSupport
    @view = @view_class.new
  end
  
  def test_includes_basic_view_support
    assert @view.kind_of?(Avatar::View::AbstractViewSupport)
  end
  
  def test_avatar_tag_empty_if_person_is_nil
    assert_equal "", @view.avatar_tag(nil)
  end
  
  def test_avatar_tag_with_no_options
    assert_equal "<img alt=\"I-am-oscar-wilde\" src=\"/images/i-am-oscar-wilde.png\" />", @view.avatar_tag(:a_person)
  end
  
  def test_avatar_tag_with_html_options
    assert_equal "<img alt=\"I-am-oscar-wilde\" class=\"avatar\" src=\"/images/i-am-oscar-wilde.png\" />", @view.avatar_tag(:a_person, {}, {:class => :avatar})
  end
  
end
