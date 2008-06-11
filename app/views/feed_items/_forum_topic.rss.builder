xml = xml_instance unless xml_instance.nil?
xml.item do
  topic = feed_item.item
	xml.title "#{topic.owner} posted #{topic.title} in #{sanitize(textilize(topic.forum.name))}"
  xml.description sanitize(textilize(topic.posts.first.body))
  xml.author "#{topic.owner.email} (#{topic.owner.f})"
  xml.pubDate topic.updated_at
  xml.link forum_topic_url(topic.forum, topic)
  xml.link forum_topic_url(topic.forum, topic)
end