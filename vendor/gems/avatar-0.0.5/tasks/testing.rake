require 'rubygems'
require 'rake'
require 'rake/testtask'

PROJECT_ROOT = File.expand_path(File.join(File.dirname(__FILE__), '..'))

LIB_DIRECTORIES = FileList.new do |fl|
  fl.include "#{PROJECT_ROOT}/lib"
  fl.include "#{PROJECT_ROOT}/test/lib/file_column/lib"
end

TEST_FILES = FileList.new do |fl|
  fl.include "#{PROJECT_ROOT}/test/**/test_*.rb"
  fl.exclude "#{PROJECT_ROOT}/test/test_helper.rb"
  fl.exclude "#{PROJECT_ROOT}/test/lib/**/*.rb"
end

Rake.application.remove_task :test

desc 'Run all tests'
Rake::TestTask.new(:test) do |t|
  t.libs = LIB_DIRECTORIES
  t.test_files = TEST_FILES
  t.verbose = true
end

desc "Build a code coverage report"
task :coverage do
  files = TEST_FILES.join(" ")
  sh "rcov -o coverage #{files} --exclude ^/Library/Ruby/,^init.rb --include lib/ --include-file ^lib/.*\\.rb"
end

namespace :coverage do
  task :clean do
    rm_r 'coverage' if File.directory?('coverage')
  end
end