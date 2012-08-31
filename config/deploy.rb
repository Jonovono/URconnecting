# RVM

# $:.unshift(File.expand_path('./lib', ENV['rvm_path']))
require "rvm/capistrano"
set :rvm_ruby_string, '1.9.2'
set :rvm_type, :user

# Bundler

require "bundler/capistrano"

# General

set :application, "URconnecting"
set :user, "jordan"

load 'deploy/assets'

# set :deploy_to, "/var/www/#{application}"
set :deploy_to, "/home/#{user}/#{application}"
set :deploy_via, :copy

set :use_sudo, false

# Git

set :scm, :git
# set :repository,  "~/#{application}/.git"
set :repository, "/Users/Jordan/documents/rails/urdating/.git"
set :branch, "master"

# VPS

role :web, "173.255.243.98"
role :app, "173.255.243.98"
role :db,  "173.255.243.98", :primary => true
role :db,  "173.255.243.98"

# Passenger

namespace :deploy do
 task :start do ; end
 task :stop do ; end
 task :restart, :roles => :app, :except => { :no_release => true } do
   run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
 end
end