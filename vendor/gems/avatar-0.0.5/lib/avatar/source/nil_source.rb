require 'avatar/source/abstract_source'

module Avatar # :nodoc:
  module Source # :nodoc:
    # A really dumb implementation that never returns a URL.
    # Can be helpful for testing.  Also used in GravatarSource::default_source.
    class NilSource
      include AbstractSource
      
      # Always returns nil.
      def avatar_url_for(person, options = {})
        nil
      end
      
    end
  end
end