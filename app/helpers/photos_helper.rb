module PhotosHelper
  
  # Rails automatically includes this, but not until after this file,
  # so the :image_path won't exist for the alias_method_chain call, below.
  # Thus, we include it now:
  include ActionView::Helpers::AssetTagHelper
  
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

  def image_path_with_photo(source_or_photo, size = :square)
    source_or_photo.kind_of?(Photo) ? photo_path(source_or_photo, size) : image_path_without_photo(source_or_photo)
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
  
  alias_method_chain :image_path, :photo
  
end