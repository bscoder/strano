#require 'capistrano-deploy'
require "bundler/capistrano"
require "rvm/capistrano"
require 'capistrano-unicorn'
require "delayed/recipes"

set :shared_files, %w(config/database.yml db/production.sqlite3 config/unicorn.rb config/strano.yml)

require 'capistrano/shared_file'

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

set :unicorn_pid, "#{current_path}/tmp/pids/unicorn.pid"

server 'hgsentry.bscoder.ru', :app, :web, :db,  :primary => true

after 'deploy:restart', 'unicorn:reload'    # app IS NOT preloaded
after 'deploy:restart', 'unicorn:restart'   # app preloaded
after 'deploy:restart', 'unicorn:duplicate' # before_fork hook implemented (ze
after 'deploy:setup', 'conf:upload_prod_confs'

namespace :conf do
  desc "Upload production configs"
  task :upload_confs do
    upload 'config/database-prod.yml', "#{shared_path}/files/config/database.yml"
    upload 'config/unicorn.rb', "#{shared_path}/files/config/unicorn.rb"
    upload 'config/strano.yml', "#{shared_path}/files/config/strano.yml"
  end
end

namespace :deploy do
  task :db_create do    
    run "cd #{current_path} && #{rake} db:version RAILS_ENV=#{rails_env} || ( #{rake} db:create RAILS_ENV=#{rails_env} && #{rake} db:schema:load RAILS_ENV=#{rails_env} && #{rake} db:seed RAILS_ENV=#{rails_env})"
  end

  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
  end
end
