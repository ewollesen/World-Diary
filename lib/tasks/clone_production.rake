namespace :db do

  desc "Clones the production database"
  task :clone do
    puts %x{ps xa | grep wd_development | awk '{print $1}' | xargs kill}
    Rake::Task["db:drop"].invoke
    puts %x{ssh wd.xmtp.net pg_dump --create wd_production | sed 's/wd_production/wd_development/g' | psql -U wd template1}
    Rake::Task["db:migrate"].invoke
    puts %x{rsync -av wd.xmtp.net:/opt/wd/shared/uploads/ #{Rails.public_path + "uploads/"}}
  end

end
