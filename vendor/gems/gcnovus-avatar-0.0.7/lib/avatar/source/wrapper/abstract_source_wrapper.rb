require 'avatar/source/abstract_source'

module Avatar
  module Source
    module Wrapper
      class AbstractSourceWrapper
        include Avatar::Source::AbstractSource
        
        attr_reader :underlying_source
        
        # Create a new Wrapper
        def initialize(underlying_source)
          raise ArgumentError.new("underlying_source must be Source") unless underlying_source.kind_of?(Avatar::Source::AbstractSource)
          @underlying_source = underlying_source
        end
        
        # Return nil if the underlying_source does; otherwise, calls <code>wrap</code>,
        # passing the returned URL and the person and options passed.
        def avatar_url_for(person, options = {})
          url = @underlying_source.avatar_url_for(person, options)
          url.nil? ? nil : wrap(url, person, options)
        end
        
        # Apply appropriate wrapping of the +url+ returned by <code>underlying_source</code>.
        # Will never be called with a nil +url+.
        def wrap(url, person, options)
          raise NotImplementedError('subclasses must override wrap(url, person, options)')
        end
        
      end
    end
  end
end