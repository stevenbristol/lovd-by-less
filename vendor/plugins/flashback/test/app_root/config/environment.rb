require 'config/boot'

Rails::Initializer.run do |config|
  config.log_level = :debug
  config.cache_classes = false
  config.whiny_nils = true
  config.load_paths << "#{RAILS_ROOT}/../../lib"
  config.plugin_paths << '..'
  config.plugins = [File.basename(File.expand_path('.'))]
end

Dependencies.log_activity = true
