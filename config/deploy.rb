#require 'capistrano-deploy'
require "bundler/capistrano"
require "rvm/capistrano"
require 'capistrano-unicorn'

set :application, "strano"
set :repository,  "https://github.com/bscoder/strano.git"
set :branch,  "test_unicorn";
set :scm, :git

set :rvm_ruby_string, "ruby-2.0.0-p451@strano"
set :rvm_type, :user

set :use_sudo, false
#set :scm_verbose, true

set :deploy_via, :remote_cache

set :deploy_to, "/home/webmaster/#{application}"
set :user, "webmaster"

server 'hgsentry.bscoder.ru', :app, :web, :db,  :primary => true

after 'deploy:restart', 'unicorn:reload'    # app IS NOT preloaded
after 'deploy:restart', 'unicorn:restart'   # app preloaded
after 'deploy:restart', 'unicorn:duplicate' # before_fork hook implemented (ze

namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
  end
end
