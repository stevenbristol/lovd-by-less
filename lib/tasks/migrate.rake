task :mig do
  puts 'rake db:migrate RAILS_ENV="development"'
  system "rake db:migrate RAILS_ENV='development'"
  puts "rake db:test:clone"
  system "rake db:test:clone"
  if !ENV['a'].nil? && ENV['a'].size > 0
    puts "NOT RUNNING: rake annotate_models"
  else
    system "rake annotate_models"
  end
end
