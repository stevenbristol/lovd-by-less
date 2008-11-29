$:.unshift File.expand_path(File.dirname(__FILE__))
require 'avatar/source/abstract_source'
require 'avatar/source/gravatar_source'

# Helpers for displaying avatars.
# Usage in Rails:
#   # in app/helpers/ProfileHelper.rb:
#   include Avatar::ActionView::Support
#
#   # in app/views/profiles/show.html.erb:
#   <%= avatar_for @person => current_person %>
#
# By default, Avatar::source is a GravatarSource
module Avatar
  
  @@source = Avatar::Source::GravatarSource.new
  @@default_avatar_options = {}
  
  def self.source
    @@source.dup
  end
  
  def self.source=(source)
    raise ArgumentError.new("#{source} is not an Avatar::Source::AbstractSource") unless source.kind_of?(Avatar::Source::AbstractSource)
    @@source = source
  end
  
  def self.default_avatar_options
    @@default_avatar_options.dup
  end
  
  def self.default_avatar_options=(options)
    raise ArgumentError.new("#{options} is not a Hash") unless options.kind_of?(Hash)
    @@options = options
  end
  
end