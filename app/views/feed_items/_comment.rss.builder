c ||= comment
c ||= feed_item.item

xml = xml_instance unless xml_instance.nil?
xml.item do
  xml.title commentable_text(c, false)
  xml.link profile_feed_item_url(@profile, c)
  xml.guid profile_feed_item_url(@profile, c)
  xml.description sanitize(textilize(c.comment))
  xml.author "#{c.profile.email} (#{c.profile.f})"
  xml.pubDate c.updated_at
end