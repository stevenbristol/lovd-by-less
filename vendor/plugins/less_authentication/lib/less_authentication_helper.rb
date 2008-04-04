module LessAuthenticationHelper
  def less_login_form object = :user, image = "login.gif", options = {}
    "<div class=\"form\">" +
    form_tag(object,{:url=>{:action=>'login'},:html=>{:method=>:put}}.update(options)) +
    "<p><label>Login</label>" + text_field(object,:login) +
    "<br/><label>Password</label>" + password_field(object,:password) +
    "<br/><br/>" + image_submit_tag(image) + "</p></form></div>"
  end
end
