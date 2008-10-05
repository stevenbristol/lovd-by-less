require File.dirname(__FILE__) + '/lib/less_reverse_captcha'

ActiveRecord::Base.send(:include, Less::ReverseCaptcha::Validations)
ActionView::Base.send(:include, Less::ReverseCaptcha::Helper)
