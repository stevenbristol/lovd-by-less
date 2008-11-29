require 'avatar/source/abstract_source'

module Avatar # :nodoc:
  module Source # :nodoc:
    # Source representing a constant URL.
    # Good as a default or last-resort source.
    class StaticUrlSource
      include AbstractSource
      
      attr_accessor :url
      
      # Create a new source with static url +url+.
      def initialize(url)
        raise ArgumentError.new("URL cannot be nil") if url.nil?
        @url = url.to_s
      end
      
      # Returns nil if person is nil; the static url otherwise.
      def avatar_url_for(person, options = {})
        person.nil? ? nil : url
      end
      
    end
  end
end