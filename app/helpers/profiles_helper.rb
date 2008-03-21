module ProfilesHelper
  
  def icon profile, size = :small, img_opts = {}
    return link_to(image_tag(icon_path( profile, size), {:title=>profile.full_name, :alt=>profile.full_name, :class=>size}.merge(img_opts)), profile_path(profile)) if profile.icon.blank?
    link_to(image_tag(icon_path( profile, size), {:title=>profile.full_name, :alt=>profile.full_name, :class=>size}.merge(img_opts)), profile_path(profile)) rescue ''
  end
  
  
  
  def icon_path profile = nil, size = :small
    return "/images/avatar_default_#{size}.png" if profile.icon.blank?
    url_for_image_column(profile, :icon, size) rescue "/images/avatar_default_#{size}.png"
  end
  
  def location_link profile = @p
    return profile.location if profile.location == Profile::NOWHERE
    link_to h(profile.location), search_profiles_path.add_param('search[location]' => profile.location)
  end
end
