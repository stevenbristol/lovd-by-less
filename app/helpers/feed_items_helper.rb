module FeedItemsHelper
  def x_feed_link feed_item
    link_to_remote image_tag('delete.png', :class => 'png', :width=>'12', :height=>'12'), :url => profile_feed_item_path(@profile, feed_item), :method => :delete
  end
  
  
  def commentable_text comment, in_html = true
    parent = comment.commentable
    case parent.class.name
    when 'Profile'
      "#{link_to_if in_html, comment.profile.f, comment.profile} wrote a comment on #{link_to_if in_html, parent.f+'\'s', profile_path(parent)} wall"
    when 'Blog'
      "#{link_to_if in_html, comment.profile.f, comment.profile} commented on #{link_to_if in_html, h(parent.title), profile_blog_path(parent.profile, parent)}"
    end
  end
end
