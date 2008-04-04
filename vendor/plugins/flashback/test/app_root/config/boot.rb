unless defined?(RAILS_ROOT)
  root_path = File.join(File.expand_path('.'), 'test/app_root')

  unless RUBY_PLATFORM =~ /(:?mswin|mingw)/
    require 'pathname'
    root_path = Pathname.new(root_path).cleanpath(true).to_s
  end

  RAILS_ROOT = root_path
end

unless defined?(RAILS_FRAMEWORK_ROOT) 
  RAILS_FRAMEWORK_ROOT = ENV['RAILS_FRAMEWORK_ROOT'] || "#{RAILS_ROOT}/vendor/rails"
end

unless defined?(Rails::Initializer)
  if File.directory?(RAILS_FRAMEWORK_ROOT)
    require "#{RAILS_FRAMEWORK_ROOT}/railties/lib/initializer"
  else
    require 'rubygems'

    environment_without_comments = IO.readlines(File.dirname(__FILE__) + '/environment.rb').reject { |l| l =~ /^#/ }.join
    environment_without_comments =~ /[^#]RAILS_GEM_VERSION = '([\d.]+)'/
    rails_gem_version = $1

    if version = defined?(RAILS_GEM_VERSION) ? RAILS_GEM_VERSION : rails_gem_version
      # Asking for 1.1.6 will give you 1.1.6.5206, if available -- makes it easier to use beta gems
      rails_gem = Gem.cache.search('rails', "~>#{version}.0").sort_by { |g| g.version.version }.last

      if rails_gem
        gem "rails", "=#{rails_gem.version.version}"
        require rails_gem.full_gem_path + '/lib/initializer'
      else
        STDERR.puts %(Cannot find gem for Rails ~>#{version}.0:
    Install the missing gem with 'gem install -v=#{version} rails', or
    change environment.rb to define RAILS_GEM_VERSION with your desired version.
  )
        exit 1
      end
    else
      gem "rails"
      require 'initializer'
    end
  end

  Rails::Initializer.run(:set_load_path)
end
