class AccountMailer < ActionMailer::Base
  
  def signup(user)
    @subject        = "Signup info from #{SITE_NAME}"
    @recipients     = user.profile.email
    @body['user']   = user
    @from           = MAILER_FROM_ADDRESS
    @sent_on        = Time.new
    @headers        = {}
  end
  

  def forgot_password(email, name, login, password)
    @subject        = "Password reset from #{SITE_NAME}"
    @body['user']   = [email, name, login, password]
    @recipients     = email
    @from           = MAILER_FROM_ADDRESS
    @sent_on        = Time.new
    @headers        = {}
  end
  
  
  def follow inviter, invited, description
    @subject        = "Follow notice from #{SITE_NAME}"
    @recipients     = invited.email
    @body['inviter']   = inviter
    @body['invited']   = invited
    @body['description'] = description
    @from           = MAILER_FROM_ADDRESS
    @sent_on        = Time.new
    @headers        = {}
  end
end
