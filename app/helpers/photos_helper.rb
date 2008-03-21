module PhotosHelper
  
  
  
  def image photo, size = :square, img_opts = {}
    return image_tag(image_path( photo, size), :class => size) if photo.image.blank?
    img_tag = image_tag(image_path( photo, size), {:title=>photo.caption, :alt=>photo.caption, :class=>size}.merge(img_opts))
    img_tag
  end
  
  
  
  def image_path photo = nil, size = :square
    return "/images/missing_#{size}.png" if photo.image.blank?
    if size
      path = url_for_image_column(photo, :image, size) rescue path = "/images/missing_#{size}.png"
      # QUESTION: Is there a way to do a file column return on a fixture and return a
      # fake path when the actual path DNE?  Returns nil if file missing
      path = "/images/missing_#{size}.png" if path.nil?
    else
      path = url_for_file_column(photo, :image) rescue path = "/images/missing_.png"
      # QUESTION: Is there a way to do a file column return on a fixture and return a
      # fake path when the actual path DNE?  Returns nil if file missing
      path = "/images/missing_.png" if path.nil? 
    end
    return path
  end


end
