xml = xml_instance unless xml_instance.nil?
xml.item do
  b = feed_item.item
  xml.title "#{b.profile.f} blogged #{time_ago_in_words b.created_at} #{b.title}"
  xml.description sanitize(textilize(b.body))
  xml.author "#{b.profile.email} (#{b.profile.f})"
  xml.pubDate b.updated_at
  xml.link profile_blog_url(b.profile, b)
  xml.guid profile_blog_url(b.profile, b)
end