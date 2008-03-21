xml = xml_instance unless xml_instance.nil?
xml.item do
  f = feed_item.item
  xml.title "#{f.inviter.f} is now a #{f.description f.inviter} of #{f.invited.f}"
  xml.description "#{f.inviter.f}'s network in #{SITE_NAME} has been updated."
  xml.author "#{f.invited.email} (#{f.invited.f})"
  xml.pubDate feed_item.created_at
  xml.link profile_url( (@profile==f.invited ? f.inviter : f.invited ) )
  xml.guid profile_url( (@profile==f.invited ? f.inviter : f.invited ) )
end