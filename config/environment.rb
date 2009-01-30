
RAILS_GEM_VERSION = '2.2.2' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  
  # Cookie sessions (limit = 4K)
  # WARNING: You MUST generate a new secret (use "rake secret") and add it below!
  config.action_controller.session = {
    :session_key => '_your_app_name',
    :secret      => '0677a17f4e94869409e7aecb29a00fd9' # <- New secret key goes here
  }
  config.action_controller.session_store = :active_record_store

  # Use SQL instead of Active Record's schema dumper when creating the test database.
  # This is necessary if your schema can't be completely dumped by the schema dumper, 
  # like if you have constraints or database-specific column types
  # config.active_record.schema_format = :sql

  # Activate observers that should always be running
  # config.active_record.observers = :cacher, :garbage_collector

  # Make Active Record use UTC-base instead of local time
  config.time_zone = 'UTC'
  
  # Gem dependencies
  config.gem 'will_paginate', :version => '~> 2.2.2'
  config.gem 'colored', :version=> '1.1'
  config.gem 'youtube-g', :version=> '0.4.9.9', :lib=>'youtube_g'
  config.gem 'uuidtools', :version=> '1.0.4'
  config.gem 'hpricot', :version=> '0.6.164'
  config.gem 'mocha', :version=> '0.9.3'
  config.gem 'redgreen', :version=> '1.2.2' unless ENV['TM_MODE']
  config.gem 'gcnovus-avatar', :version=> '0.0.7', :lib => 'avatar'
  
  
  
  
end

Less::JsRoutes.generate!
