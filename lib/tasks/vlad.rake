begin
  require "vlad"
  require "bundler/vlad"
  Vlad.load :scm => :git
  require "vlad/maintenance"

  namespace :vlad do
    remote_task :update_symlinks, :roles => :app do
      shared_links = {
        "uploads" => "public/uploads",
        "config/database.yml" => "config/database.yml",
        ".ruby-version" => ".ruby-version",
      }
      ops = shared_links.map do |sp,rp|
        dir = File.dirname("#{latest_release}/#{rp}")
        run "[ -d \"#{dir}\" ] || mkdir -p \"#{dir}\""
        $stderr.puts "sp %p\nrp %p\ndir %p" % [sp, rp, dir]
        # File.exists?(dir) || FileUtils.mkdir_p(dir)
        "ln -fs #{shared_path}/#{sp} #{latest_release}/#{rp}"
      end
      run ops.join(" && ")
    end

    remote_task :update, :roles => :app do
      Rake::Task["vlad:bundle:install"].invoke
    end

    remote_task :write_sha1, :roles => :app do
      run "cd #{shared_path}/../scm/repo && echo `git rev-parse HEAD` > #{current_release}/public/git_revision.txt"
    end
  end

  desc "Deploy without migrations."
  task :deploy => ["vlad:update",
                   "vlad:assets:precompile",
                   "vlad:cleanup",
                   "vlad:start_app",
                   "vlad:write_sha1",]

  namespace :deploy do
    desc "Deploy with migrations."
    task :long => ["vlad:update",
                   "vlad:assets:precompile",
                   "vlad:maintenance:on",
                   "vlad:migrate",
                   "vlad:maintenance:off",
                   "vlad:cleanup",
                   "vlad:start_app",
                   "vlad:write_sha1",]
  end
rescue LoadError
  # do nothing
end
