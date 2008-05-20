module ForumTopicsHelper
  
  def topic_last_post_info(topic)
    unless (topic.posts.empty?)
      post = topic.posts.last
      "#{time_ago_in_words post.created_at} ago by "+link_to(post.owner.f, profile_path(post.owner))
    else
      "No posts"
    end
  end
  
  def topic_details(topic)
    "#{topic.posts.count} "+(topic.posts.count == 1 ? "post" : "posts")
  end
  
end
