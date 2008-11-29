require 'avatar/source/abstract_source'

module Avatar # :nodoc:
  module Source # :nodoc:
    class SourceChain
      include AbstractSource
      
      # :nodoc:
      def initialize
        clear!
      end
      
      # Clear the chain
      def clear!
        @chain = []
      end
      
      # Retrieve the +n+<sup>th</sup> Source.
      def [](n)
        @chain[n]
      end
      
      # Add a source to the chain.  +source+ must be an instance of (a subclass of) Avatar::Source::AbstractSource.
      def add_source(source)
        raise ArgumentError.new("#{source} is not an Avatar::Source::AbstractSource") unless source.kind_of?(Avatar::Source::AbstractSource)
        @chain << source
      end
      
      # Alias for <code>add_source</code>
      def <<(source)
        add_source(source)
      end
      
      # True unless a Source has been added.
      def empty?
        @chain.empty?
      end
      
      # Iterate through the chain and return the first URL returned.
      # Any error raised will propagate.  Duplicates +options+ before
      # passing so each Source receives the same arguments.
      def avatar_url_for(person, options = {})
        @chain.each do |source|
          result = source.avatar_url_for(person, options.dup)
          return result unless result.nil?
        end
        return nil
      end
      
    end
  end
end