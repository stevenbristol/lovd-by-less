# Old Rails style init:
if Object.const_defined?(:RAILS_ENV)
  # redirect to the new style
  require File.expand_path(File.join(File.dirname(__FILE__), 'lib', 'rails', 'init'))
end
