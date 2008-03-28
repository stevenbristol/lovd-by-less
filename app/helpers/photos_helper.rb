module PhotosHelper
  
  def self.included(base)
    #this gets auto-included, but only later, so do it now or :image_path won't be defined
    base.send :include, ActionView::Helpers::AssetTagHelper
    
    #replace image_path with a version that understands stored photos:
    unless base.method_defined?(:image_path_without_photo)
      base.send :alias_method, :image_path_without_photo, :image_path
    end
    
    # this has to happen after the :alias_method or the method defined below will be overwritten:
    base.send :include, PhotosHelper::InstanceMethods
  end
  
  module InstanceMethods
    def image photo, size = :square, img_opts = {}
      return image_tag(image_path( photo, size), :class => size) if photo.image.blank?
      img_tag = image_tag(image_path( photo, size), {:title=>photo.caption, :alt=>photo.caption, :class=>size}.merge(img_opts))
      img_tag
    end
  
    def photo_path photo = nil, size = nil
      path = nil
      unless photo.nil? || photo.image.blank?
        path = url_for_file_column(photo, :image, size) rescue nil
      end
      path = missing_photo_path(size) if path.nil?
      return path
    end
  
    def image_path(source_or_photo, size = :square)
      source_or_photo.respond_to?(:image) ? photo_path(source_or_photo, size) : image_path_without_photo(source_or_photo)
    end

    def allowed_photo_sizes
      [:square, :small]
    end

    def missing_photo_path(size)
      if allowed_photo_sizes.include?(size)
        "/images/missing_#{size}.png"
      else
        '/images/missing.png'
      end
    end
  end
  
end