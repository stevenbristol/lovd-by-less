namespace :gems do
  namespace :dependent do
    desc "Install gems required for lovd-by-less"
    task :install do
      windoz = /win32/ =~ RUBY_PLATFORM
      gems = %w[
          rflickr
          rmagick
          RedCloth
        ]
      gems << 'win32console' if windoz
      sudo = windoz ? '' : 'sudo '
      gems.each do |gem|
        `#{sudo}gem install #{gem}`
      end
      `rake gems:build`
    end
  end
end

namespace :lovdbyless do
  task :check do
    puts "TODO - check that all config ready"
  end
  
  desc "Getting started with lovd-by-less"
  task :getting_started => [
    "environment", 
    "lovdbyless:check",
    "gems:dependent:install", 
    "db:create:all", "mig"
    ] do
    puts "Finished setting up enviornment and application!"
  end
end
