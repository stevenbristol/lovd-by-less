require 'avatar/source/wrapper/abstract_source_wrapper'
require 'action_view/helpers/asset_tag_helper'

module Avatar # :nodoc:
  module Source # :nodoc:
    module Wrapper
      # Wraps a Source using Rails' <code>AssetTagHelper#image_path</code>,
      # which can turn path URLs (e.g. '/images/my_avatar.png')
      # into absolute URLs( e.g. 'http://assets.mysite.com/images/my_avatar.png').
      class RailsAssetSourceWrapper < AbstractSourceWrapper
      
        attr_reader :url_helper
      
        private :url_helper
      
        def initialize(source)
          super
          @url_helper = Object.new
          @url_helper.extend(ActionView::Helpers::AssetTagHelper)
        end
      
        # Passes +url+ to <code>AssetTagHelper#image_path</code>.  Raises
        # an error if it cannot generate a fully-qualified URI.  Try
        # setting <code>ActionController::Base.asset_host</code> to
        # avoid this error.
        def wrap(url, person, options = {})
          # url will never be nil b/c of guarantee in AbstractSourceWrapper
          result = url_helper.image_path(url)
          raise "could not generate protocol and host for #{url}.  Have you set ActionController::Base.asset_host?" unless result =~ /^http[s]?\:\/\//
          result
        end
      
      end
    end
  end
end