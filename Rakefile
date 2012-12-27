#!/usr/bin/env rake
# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

Wd::Application.load_tasks

begin
  require "vlad"
  require "vlad/maintenance"
  Vlad.load :scm => :git, :app => :passenger
rescue LoadError
  # do nothing
end
