class ForumMailer < ActionMailer::Base
  
  def new_post(user,post)
    @subject        = "New post on #{post.topic.title} from #{SITE_NAME}"
    @recipients     = user.profile.email
    @body['user']   = user
    @body['post']   = post
    @from           = MAILER_FROM_ADDRESS
    @sent_on        = Time.new
    @content_type = "text/html"

  end

end
