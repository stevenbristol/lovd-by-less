require 'benchmark'

if defined?(Rails::VERSION::STRING) && Rails::VERSION::STRING < "1.2.0"
  $stderr.puts "The QueryStats plugin requires Rails >= 1.2.0"
elsif !ActionController::Base.included_modules.include?(QueryStats::Labeler)
  ActiveRecord::Base.connection.class.send :include, QueryStats::Recorder
  ActionController::Base.send :include, QueryStats::Labeler
  ActionController::Base.send :include, QueryStats::Logger
  ActionController::Base.helper QueryStats::Helper
end
