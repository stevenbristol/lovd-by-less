require File.dirname(__FILE__) + '/lib/less_captcha'

ActiveRecord::Base.send(:include, Less::Captcha::Validations)
ActiveRecord::Base.send(:include, Less::Captcha::InstanceMethods)
ActionView::Base.send(:include, Less::Captcha::Helper)