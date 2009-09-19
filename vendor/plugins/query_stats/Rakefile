require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

desc 'Default: run unit tests.'
task :default => :test

desc "pre-commit task"
task :pc => "test:multi"

desc 'Test the query_stats plugin.'
Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = true
end

desc 'Generate documentation for the query_stats plugin.'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'QueryStats'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README')
  rdoc.rdoc_files.include('CHANGELOG')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

DB_ADAPTERS = %w[sqlite3 mysql]
RAILS_VERSIONS = %w[1.2.6 2.0.2 2.1.1 2.2.2]

namespace :test do
  desc "test with multiple versions of rails and multiple adapters"
  task :multi do
    RAILS_VERSIONS.each do |rails_version|
      puts "Testing with Rails #{rails_version}"
      DB_ADAPTERS.each do |db_adapter|
        puts " - Adapter: #{db_adapter}"
        sh "RAILS_VERSION='#{rails_version}' DB='#{db_adapter}' rake test > /dev/null 2>&1"
      end
    end
  end
end
