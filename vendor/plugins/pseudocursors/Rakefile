require 'rake'
require 'rake/rdoctask'
require 'spec/rake/spectask'

desc 'Default: run unit tests.'
task :default => :test

desc 'Test the pseudo_cursors plugin.'
Spec::Rake::SpecTask.new(:test) do |t|
  t.spec_files = 'spec/**/*_spec.rb'
end

desc 'Generate documentation for the pseudo_cursors plugin.'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'PseudoCursors'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
