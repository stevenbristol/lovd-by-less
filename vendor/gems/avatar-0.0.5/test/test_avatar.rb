require File.dirname(__FILE__) + '/test_helper.rb'

class TestAvatar < Test::Unit::TestCase
  
  def setup
  end
  
  def test_load_path_includes_avatar_lib
    lib_path = File.expand_path(File.join(File.dirname(__FILE__), ['..', 'lib']))
    assert $:.include?(lib_path)
  end
end
