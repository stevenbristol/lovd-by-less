require File.dirname(__FILE__) + '/test_helper.rb'
require 'avatar/source/gravatar_source'
require 'avatar/source/static_url_source'
require 'digest/md5'

class TestGravatarSource < Test::Unit::TestCase
  
  def setup
    @source = Avatar::Source::GravatarSource.new
    @gary = Person.new('gary@example.com', 'Gary Glumph')
    @email_hash = Digest::MD5::hexdigest(@gary.email)
  end
  
  def test_nil_when_person_is_nil
    assert_nil @source.avatar_url_for(nil)
  end
  
  def test_not_nil_when_person_is_not_nil
    assert_equal "http://www.gravatar.com/avatar/#{@email_hash}", @source.avatar_url_for(@gary)
  end
  
  def test_field
    name_hash = Digest::MD5::hexdigest(@gary.name.downcase)
    assert_equal "http://www.gravatar.com/avatar/#{name_hash}", @source.avatar_url_for(@gary, :gravatar_field => :name)
  end
  
  def test_site_wide_default_string
    @source.default_source = 'http://fazbot.com'
    assert_equal "http://www.gravatar.com/avatar/#{@email_hash}?default=http://fazbot.com", @source.avatar_url_for(@gary)
  end
  
  def test_site_wide_default_source
    @source.default_source = Avatar::Source::StaticUrlSource.new('http://funky.com')
    assert_equal "http://www.gravatar.com/avatar/#{@email_hash}?default=http://funky.com", @source.avatar_url_for(@gary)
  end
  
  def test_site_wide_default_nil
    @source.default_source = Avatar::Source::StaticUrlSource.new('http://plumb.com')
    @source.default_source = nil
    assert_equal "http://www.gravatar.com/avatar/#{@email_hash}", @source.avatar_url_for(@gary)
  end

  def test_default_override
    @source.default_source = Avatar::Source::StaticUrlSource.new('does it really matter?')
    assert_equal "http://www.gravatar.com/avatar/#{@email_hash}?default=http://gonzo.com", @source.avatar_url_for(@gary, :gravatar_default_url => 'http://gonzo.com')
  end
  
  def test_raises_error_if_default_only_path
    assert_raises(RuntimeError) {
      @source.avatar_url_for(@gary, :gravatar_default_url => 'foo')
    }
  end
  
  def test_size
    assert_equal "http://www.gravatar.com/avatar/#{@email_hash}?size=70", @source.avatar_url_for(@gary, :gravatar_size => 70)
    assert_equal "http://www.gravatar.com/avatar/#{@email_hash}?size=109", @source.avatar_url_for(@gary, :size => 109)
    assert_equal "http://www.gravatar.com/avatar/#{@email_hash}?size=62", @source.avatar_url_for(@gary, :s => '62x62')
  end
  
  def test_invalid_size_does_not_pass_through
    assert_equal "http://www.gravatar.com/avatar/#{@email_hash}", @source.avatar_url_for(@gary, :s => :small)
  end
  
  def test_rating
    assert_equal "http://www.gravatar.com/avatar/#{@email_hash}?rating=G", @source.avatar_url_for(@gary, :gravatar_rating => 'G')
    assert_equal "http://www.gravatar.com/avatar/#{@email_hash}?rating=R", @source.avatar_url_for(@gary, :rating => 'R')
    assert_equal "http://www.gravatar.com/avatar/#{@email_hash}?rating=PG", @source.avatar_url_for(@gary, :r => 'PG')
  end
  
  def test_invalid_rating_does_not_pass_through
    assert_equal "http://www.gravatar.com/avatar/#{@email_hash}", @source.avatar_url_for(@gary, :r => 'EVIL')
  end
  
  def test_default_always_at_end
    assert_equal "http://www.gravatar.com/avatar/#{@email_hash}?rating=any&default=http://gonzo.com",  @source.avatar_url_for(@gary, :gravatar_rating => :any, :gravatar_default_url => 'http://gonzo.com')
    assert_equal "http://www.gravatar.com/avatar/#{@email_hash}?size=110&default=http://gonzo.com",  @source.avatar_url_for(@gary, :gravatar_size => 110, :gravatar_default_url => 'http://gonzo.com')
  end
  
end
