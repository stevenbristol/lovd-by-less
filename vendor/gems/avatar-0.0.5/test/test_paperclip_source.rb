$: << File.expand_path(File.join(File.dirname(__FILE__), ['lib', 'paperclip', 'lib']))
require File.join(File.dirname(__FILE__), 'test_helper.rb')
require File.join(File.dirname(__FILE__), ['lib', 'paperclip', 'init'])
require 'avatar/source/paperclip_source'

class PaperclipUser < ActiveRecord::Base
  has_attached_file :avatar, 
                    :styles => { :medium => "300x300>",
                                   :thumb  => "100x100>" },
                    :default_style => :medium,
                    :path => ":rails_root/public/images/:class/:id/:attachment/:style/:basename.:extension",
                    :url => "/images/:class/:id/:attachment/:style/:basename.:extension"

  has_attached_file :icon, 
                    :styles => { :small => "80x80" },
                    :default_style => :small,
                    :path => ":rails_root/public/images/:class/:id/:attachment/:style/:basename.:extension",
                    :url => "/images/:class/:id/:attachment/:style/:basename.:extension"
end

class TestPaperclipSource < Test::Unit::TestCase
  
  def setup
    @source = Avatar::Source::PaperclipSource.new
    png = File.new(File.join(File.dirname(__FILE__), ['lib', 'user_suit.png']))
    assert File.exists?(png.path)
    @user_with_avatar = PaperclipUser.create!(:email => 'clarence@example.com', :avatar => png)
    @user_with_icon = PaperclipUser.create!(:email => 'bobbi@example.com', :icon => png)
    @user_without_avatar = PaperclipUser.create!(:email => 'brunhilde@example.com')
  end
  
  def test_avatar_url_is_nil_if_person_is_nil
    assert_nil @source.avatar_url_for(nil)
  end
  
  def test_avatar_url_is_nil_if_person_has_no_avatar
    assert_nil @source.avatar_url_for(@user_without_avatar)
  end
  
  def test_avatar_url_for_person_with_avatar
    assert_equal "/images/paperclipusers/#{@user_with_avatar.id}/avatars/medium/user_suit.png", @source.avatar_url_for(@user_with_avatar)
  end

  def test_avatar_url_is_nil_for_invalid_size
    assert_nil @source.avatar_url_for(@user_with_avatar, :paperclip_style => :not_a_valid_style)
  end
  
  def test_avatar_url_for_person_with_icon_and_custom_file_column_field
    assert_equal "/images/paperclipusers/#{@user_with_icon.id}/icons/small/user_suit.png", @source.avatar_url_for(@user_with_icon, :paperclip_field => :icon)
  end
  
end
