require 'avatar'

module Avatar # :nodoc:
  module View # :nodoc:
    module AbstractViewSupport
    
      def avatar_url_for(person, options = {})
        default_options = Avatar::default_avatar_options || {}
        options = default_options.merge(options)
        Avatar::source.avatar_url_for(person, options)
      end
      
    end
  end
end