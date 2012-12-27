require "bundler/vlad"

set :application, "wd"
set :deploy_to, "/opt/#{application}"
set :repository, "black.xmtp.net:/home/git/wd.git"
set :revision, "origin/master"
set :rbenv_version, "1.9.3-p194"
set :bundle_without, [:development, :test,]
set :user, "ericw"

task :rpain do
  set :domain, "rpain-deploy"
end

task :pain do
  set :domain, "pain-deploy"
end


namespace :vlad do
  desc "Symlinks the configuration files"
  remote_task :symlink_config, :roles => :web do
    %w(database.yml).each do |file|
      run "ln -s #{shared_path}/config/#{file} #{current_path}/config/#{file}"
    end
  end

  desc "Full deployment cycle: Update, migrate, restart, cleanup"
  remote_task :deploy, :roles => :app do
    Rake::Task['vlad:update'].invoke
    Rake::Task['vlad:symlink_config'].invoke
    Rake::Task['vlad:migrate'].invoke
    Rake::Task['vlad:start_app'].invoke
    Rake::Task['vlad:cleanup'].invoke
  end
end
