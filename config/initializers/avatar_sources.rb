require 'avatar'
require 'avatar/source/file_column_source'
require 'avatar/source/source_chain'
require 'avatar/source/static_url_source'
require 'avatar/source/wrapper/rails_asset_source_wrapper'
require 'avatar/source/wrapper/string_substitution_source_wrapper'
require 'sized_gravatar_source'

# order:
# 1.  FileColumn(Profile#icon)
# 2.  Gravatar(Profile#email), with default
#       a RailsAssetSourceWrapper containing
#         a StringSubstitutionSourceWrapper containing
#           a StaticUrlSource ('/images/avatar_default_#{size}.png')
#
# Gravatar does not understand :small, :medium, and :big,
# so we must translate using SizedGravatarSource

default = Avatar::Source::Wrapper::RailsAssetSourceWrapper.new(
  Avatar::Source::Wrapper::StringSubstitutionSourceWrapper.new(
    Avatar::Source::StaticUrlSource.new('/images/avatar_default_#{size}.png'),
    {:size => :small}
  )
)

chain = Avatar::Source::SourceChain.new
chain << Avatar::Source::FileColumnSource.new(:icon)
chain << SizedGravatarSource.new(default, :email)

Avatar::source = chain
