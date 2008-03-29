gem 'avatar', '>= 0.0.4'

require 'avatar'
require 'avatar/source/file_column_source'
require 'avatar/source/rails_asset_source'
require 'avatar/source/source_chain'
require 'sized_gravatar_source'

# order:
# 1.  FileColumn(Profile.icon)
# 2.  Gravatar(nil_source, Profile.email)
# 3.  RailsAsset('/images/avatar_default_#{size}.png)
#
# GravatarSource doesn't understand size replacement
# by default, so we create a subclass that does
# (see /lib/sized_gravatar_source.rb).
#
# The RailsAssetSource requires ActionController::Base::asset_host to be set.
# It doesn't need to be set until an avatar is generated, though, so
# it's fine to set it in a later initializer.

last_resort = Avatar::Source::RailsAssetSource.new('/images/avatar_default_#{size}.png')

chain = Avatar::Source::SourceChain.new
chain << Avatar::Source::FileColumnSource.new(:icon)
chain << SizedGravatarSource.new(last_resort, :email)

Avatar::source = chain
