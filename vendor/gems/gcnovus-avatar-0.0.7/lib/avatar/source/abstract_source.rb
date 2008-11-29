module Avatar # :nodoc:
  module Source # :nodoc:
    # To be included by classes that generate avatar URLs from profiles.
    module AbstractSource
      
      # Return an avatar URL for the person, or nil if this source cannot generate one.
      # Including classes <em>must</em> override this method.  In general, implementations
      # should return nil if +person+ is nil.
      def avatar_url_for(person, options = {})
        raise NotImplementedError.new('including class must define avatar_url_for(person, options = {})')
      end
      
    end
  end
end