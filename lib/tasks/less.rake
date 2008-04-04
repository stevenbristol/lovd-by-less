# desc "Rebuild development database"
# task :rebuild_database => [] # 'log:clear', 'db:migrate', :default]
# 
# task :all => ['log:clear', :default] do
# end
# 
# task :wipe_devel_database => :environment do
#   ActiveRecord::Base.establish_connection(:development)
#   conf = ActiveRecord::Base.configurations
#   ActiveRecord::Base.connection.execute("drop database #{conf['development']['database']};")
#   ActiveRecord::Base.connection.execute("create database #{conf['development']['database']};")
#   ActiveRecord::Base.establish_connection(:development)
# end
# 
# desc "Load fixtures data into the development database"
# task :load_fixtures_to_development_weg do
#   ActiveRecord::Base.establish_connection(:development)
#   require 'active_record/fixtures'
# 
#   fixtures_to_load = ActiveRecord::Base.configurations[:fixtures_load_order]
#   if fixtures_to_load.nil?
#     raise 'Define ActiveRecord::Base.configurations[:fixtures_load_order] = [:model_name] in your environment first'
#   end
#   Fixtures.create_fixtures("test/fixtures", fixtures_to_load)
# end 
# 
# desc "Alias for :update_development task"
# task :ud => [:update_development]

desc "Commit changes to subversion and run tests"
task :ci => [:check_uncommitted_files, :default, :svn_commit]
# 
# desc "Update the project (development) and run data migrations"
# task :update_development => [:svn_update, :rebuild_database, :default]

desc "Run 'svn update' command"
task :svn_update do
  puts `svn update`
end

desc "Run 'svn commit' command"
task :svn_commit => [:check_uncommitted_files] do
  raise "\n\n!!!!! You must specify a message for the commit (example: m='some message') !!!!!\n\n" if ENV['m'].nil?
  puts `svn commit -m "#{ENV['m']}"`
  # svn_commit_result =~ /Committed revision (\d+)\.$/
  # svn_version = $1.to_i
  # puts svn_commit_result
end

desc "Check uncommitted files"
task :check_uncommitted_files do
  svn_status_result = `svn status`
  if svn_status_result.index(/^\?/)
    puts svn_status_result
    raise "\n\n!!!!! You have local files not added to subversion (note the question marks above) !!!!!\n\n"
  end 
end
# 
# desc "Trim trailing spaces and convert tab to spaces"
# task :trim_codes do 
#   include LineFormatter
#   format_dir("#{File.dirname(__FILE__)}/../../", /.*\.((rhtml)|(rb)|(yml)|(css))$/) do |line|
#     remove_trailing_whitespace(detab(line, 2))
#   end   
# end

