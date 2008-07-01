require File.dirname(__FILE__) + '/test_helper.rb'
require 'avatar/source/wrapper/rails_asset_source_wrapper'
require 'avatar/source/static_url_source'
require 'action_controller/base'

class TestRailsAssetSourceWrapper < Test::Unit::TestCase
  
  def setup
    ActionController::Base.asset_host = 'http://test.com'
    @source = Avatar::Source::StaticUrlSource.new('/')
    @wrapper = Avatar::Source::Wrapper::RailsAssetSourceWrapper.new(@source)
  end
  
  def test_returns_nil_if_underlying_source_returns_nil
    @source.instance_eval { def avatar_url_for(*args); nil; end }
    assert_nil @wrapper.avatar_url_for(:a_person)
  end
  
  def test_does_not_change_fully_qualified_uri
    @source.url = 'http://example.com/images/avatar.png'
    assert_equal 'http://example.com/images/avatar.png', @wrapper.avatar_url_for(3)
  end
  
  def test_uses_asset_host
    @source.url = '/images/avatar.png'
    assert_equal 'http://test.com/images/avatar.png', @wrapper.avatar_url_for(4)
  end
  
  def test_error_if_cannot_generate_full_uri
    ActionController::Base.asset_host = ''
    @source.url = '/images/avatar.png'
    assert_raise(RuntimeError) {
      @wrapper.avatar_url_for(4)
    }
  end
  
end