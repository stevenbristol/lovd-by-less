require 'avatar/object_support'
require 'avatar/source/abstract_source'

module Avatar # :nodoc:
  module Source # :nodoc:
    # Source for a file attachment using Paperclip.
    # See http://giantrobots.thoughtbot.com/2008/3/18/for-attaching-files-use-paperclip
    class PaperclipSource
      include AbstractSource
    
      attr_accessor :default_field, :default_style
      
      # Create a new FileColumnSource with a +default_field+ (by default, :avatar),
      # and a +default_style+ (by default, nil)
      def initialize(default_field = :avatar, default_style = nil)
        @default_field = default_field
        @default_style = default_style
      end
    
      # Returns a URL for a has_attached_file attribute, via
      # <code>person.<paperclip_field>.url</code>, passing in :paperclip_style if present.
      # Returns nil under any of the following circumstances:
      # * person is nil
      # * person.<paperclip_field> is nil
      # * person.<paperclip_field>? returns false
      # * person.<paperclip_field>.styles does not include :paperclip_style (if present)
      # Options:
      # * <code>:paperclip_field</code> - the has_attached_file column within +person+; by default, self.default_field
      # * <code>:paperclip_style</code> - one of the styles of the has_attached_file; by default, self.default_style
      def avatar_url_for(person, options = {})
        return nil if person.nil?
        options = parse_options(person, options)
        field = options[:paperclip_field]
        return nil if field.nil?
        return nil unless person.send("#{field}?".to_sym)
        avatar = person.send(field)
        style = options[:paperclip_style]
        return nil if style && !avatar.styles.keys.include?(style)
        avatar.url(style)
      end
    
      # Copies :paperclip_field and :paperclip_style from +options+, adding defaults if necessary.
      def parse_options(person, options)
        returning({}) do |result|
          result[:paperclip_field] = options[:paperclip_field] || default_field
          result[:paperclip_style] = options[:paperclip_style] || default_style
        end
      end
      
    end
  end
end