require "bundler/vlad"

set :application, "wd"
set :deploy_to, "/opt/#{application}"
set :repository, "black.xmtp.net:/home/git/wd.git"
set :revision, "origin/master"
set :rbenv_version, "1.9.3-p194"
set :bundle_without, [:development, :test,]
set :user, "ericw"
set :rbenv_setup, "PATH=~/.rbenv/bin:~/.rbenv/shims:$PATH"
set :bundle_cmd, "#{rbenv_setup} RBENV_VERSION=#{rbenv_version} bundle"
set :rake_cmd, "#{bundle_cmd} exec rake"


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
      run "ln -fs #{shared_path}/config/#{file} #{current_path}/config/#{file}"
    end
  end

  desc "Symlinks carrierwave files"
  remote_task :symlink_carrierwave, :roles => :web do
    run "[ -d #{shared_path}/uploads ] || mkdir -p #{shared_path}/uploads"
    run "ln -fs #{shared_path}/uploads #{current_path}/public/uploads"
  end

  desc "Full deployment cycle: Update, migrate, restart, cleanup"
  remote_task :deploy, :roles => :app do
    Rake::Task["vlad:update"].invoke
    Rake::Task["vlad:symlink_config"].invoke
    Rake::Task["vlad:symlink_carrierwave"].invoke
    Rake::Task["vlad:maintenance:on"].invoke
    Rake::Task["vlad:bundle:install"].invoke
    Rake::Task["vlad:precompile"].invoke
    Rake::Task["vlad:migrate"].invoke
    Rake::Task["vlad:start_app"].invoke
    Rake::Task["vlad:maintenance:off"].invoke
    Rake::Task["vlad:cleanup"].invoke
  end

  desc "Precompile assets"
  remote_task :precompile, :roles => :app do
    run "cd #{current_release} && #{rake_cmd} assets:precompile"
  end

end
