namespace :gems do
  namespace :dependent do
    desc "Install gems required for lovd-by-less"
    task :install do
      windoz = /win32/ =~ RUBY_PLATFORM
      gems = %w[
          youtube-g
          rflickr
          uuidtools
          colored
          hpricot
          tzinfo
          mocha
          redgreen
          RedCloth
          rmagick
          acts_as_ferret
          ferret
          avatar
        ]
      gems << 'win32console' if windoz
      sudo = windoz ? '' : 'sudo '
      gems.each do |gem|
        `#{sudo}gem install #{gem}`
      end
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
