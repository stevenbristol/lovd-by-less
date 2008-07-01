require 'avatar/source/wrapper/abstract_source_wrapper'
require 'action_view/helpers/asset_tag_helper'

module Avatar # :nodoc:
  module Source # :nodoc:
    module Wrapper
      # Wraps a Source using Rails' <code>AssetTagHelper#image_path</code>,
      # which can turn path URLs (e.g. '/images/my_avatar.png')
      # into absolute URLs( e.g. 'http://assets.mysite.com/images/my_avatar.png').
      class StringSubstitutionSourceWrapper < AbstractSourceWrapper
      
        attr_accessor :default_options
      
        def initialize(source, default_options = {})
          super(source)
          self.default_options = default_options || {}
        end
      
        # Passes +url+ to <code>AssetTagHelper#image_path</code>.  Raises
        # an error if it cannot generate a fully-qualified URI.  Try
        # setting <code>ActionController::Base.asset_host</code> to
        # avoid this error.
        def wrap(url, person, options = {})
          # url will never be nil b/c of guarantee in AbstractSourceWrapper
          result = apply_substitution(url, self.default_options.merge(options))
          substitution_needed?(result) ? nil : result
        end

        def default_options=(opts)
          @default_options = opts || {}
        end
        
        # For each key in +options+ replaces '#{key}' in +string+ with the
        # corresponding value in +options+.
        # +string+ should
        # be of the form '...#{variable_a}...#{variable_b}...'.  <em>Note the
        # single quotes</em>.  Double quotes will cause the variables to be
        # substituted before this method is run, which is almost
        # certainly <strong>not</strong> what you want.
        def apply_substitution(string, options)
          returning(string.dup) do |result|
            options.each do |k,v|
              result.gsub!(Regexp.new('#\{' + "#{k}" + '\}'), "#{v}")
            end
          end
        end

        def substitution_needed?(string)
          string =~ /#\{.*\}/
        end
      
      end
    end
  end
end