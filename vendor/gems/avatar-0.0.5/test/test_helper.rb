# for Rails-specific tests:
RAILS_ROOT = "#{File.dirname(__FILE__)}" unless defined?(RAILS_ROOT)
RAILS_ENV = 'test' unless defined?(RAILS_ENV)
require 'test/unit'
require 'rubygems'
require 'active_record'
require 'active_support'
require 'action_controller'
require 'action_view'

#$: << File.expand_path(File.join(File.dirname(__FILE__), ['lib', 'file_column', 'lib']))
#$: << File.expand_path(File.join(File.dirname(__FILE__), ['lib', 'paperclip', 'lib']))

#require File.join(File.dirname(__FILE__), ['lib', 'file_column', 'init'])
#require File.join(File.dirname(__FILE__), ['lib', 'paperclip', 'init'])

require File.join(File.dirname(__FILE__), ['lib', 'database'])
require File.join(File.dirname(__FILE__), ['lib', 'schema'])
require File.join(File.dirname(__FILE__), ['..', 'lib', 'avatar'])

class Person
  attr_accessor :email, :name
  def initialize(email, name = nil)
    @email = email
    @name = name || email
  end
end