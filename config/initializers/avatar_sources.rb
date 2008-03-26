require 'avatar'
require 'avatar/source/file_column_source'
require 'avatar/source/source_chain'
require 'avatar/source/string_substitution_source'
require 'sized_gravatar_source'

# order:
# 1.  FileColumn(Profile.icon)
# 2.  Gravatar(nil_source, Profile.email)
#
# Gravatar accepts a default if no gravatar exists for the
# email address passed.  Unfortunately, it needs to be
# a full URL (not just a path relative to the request).
# Thus, this won't work:
#   gravatar.default_source = Avatar::Source::StringSubstitutionSource.new('/images/avatar_default_#{size}.png')
# Instead, we have to pass in a default in the avatar_url_for
# call in app/helpers/profiles_helper
#
# Additionally, Gravatar does not understand :small, :medium, and :big,
# so we must translate using SizedGravatarSource

chain = Avatar::Source::SourceChain.new
chain << Avatar::Source::FileColumnSource.new(:icon)
chain << SizedGravatarSource.new(nil, :email)

Avatar::source = chain
