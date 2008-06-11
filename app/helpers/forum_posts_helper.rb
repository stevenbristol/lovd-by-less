module ForumPostsHelper
  
  def forum_posts_li posts
    html = ''
    posts.each do |post|
      if post.topic and post.topic.forum
        html += "<li>In #{link_to sanitize(post.topic.title), forum_topic_path(post.topic.forum, post.topic), :href => forum_topic_path(post.topic.forum, post.topic)+'#'+dom_id(post)  } #{time_ago_in_words post.created_at} ago</li>"
      end
    end
    html
  end
  
end
