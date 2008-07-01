require 'avatar/source/abstract_source'
require 'file_column_helper'

module Avatar # :nodoc:
  module Source # :nodoc:
    # For use with the FileColumn Rails plugin.
    class FileColumnSource
      include AbstractSource
      include FileColumnHelper
      
      attr_accessor :default_field
      
      def initialize(default_field = :avatar)
        raise ArgumentError.new('default_field cannot be nil') if default_field.nil?
        @default_field = default_field
      end
      
      # Returns nil if person is nil; otherwise, returns the (possibly nil) result of
      # <code>url_for_image_column</code>, passing in all of +options+ except :file_column_field.
      # Options:
      # * <code>:file_column_field</code> - the image file column within +person+; by default, :avatar
      # * <code>:file_column_version</code> - one of the versions of the file_column; no default
      # If :file_column_version is not specified, all other options are passed to
      # <code>url_for_image_column</code> as +options+ (see FileColumnHelper)
      def avatar_url_for(person, options = {})
        return nil if person.nil?
        options = parse_options(person, options)
        field = options.delete(:file_column_field) || default_field
        return nil if field.nil? || person.send(field).nil?
        options = options[:file_column_version] || options
        url_for_image_column(person, field, options)
      end
      
      def parse_options(person, options)
        options
      end
    end
  end
end