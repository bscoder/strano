source 'http://rubygems.org'

gem 'rails', '~> 3.2.12'
gem 'sqlite3'

gem 'devise'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'
end

gem 'jquery-rails'
gem 'twitter-bootstrap-rails'
gem 'omniauth-github'
gem 'grit'
gem 'inherited_resources'
gem 'kaminari'
gem 'simple_form', '~> 2'
gem 'ansible'
gem 'unicorn'

#gem 'open4'
#gem 'permanent_records'
#gem 'dotiw'
#gem 'slim'
#gem 'sinatra'
#gem 'yajl-ruby'
#gem 'faraday'
#gem 'faraday_middleware'

# While these are not needed by Strano itself, without them installed, any project
# that requires them will die when Strano tries to run a cap task. By using
# :require => nil, these don't get required/loaded into Strano, but are installed
# for projects to use if needed.
#gem 'delayed_job'#, :require => nil
gem 'delayed_job_active_record'
gem 'daemons'
gem 'whenever', :require => nil
#gem 'airbrake', :require => nil
#gem 'newrelic_rpm', :require => nil

group :development, :test do
  gem 'rspec-rails'
  gem 'factory_girl_rails'
  gem 'marked'
  gem 'ffaker'
end

group :development do
  gem 'guard'
  gem 'guard-rspec'
  gem 'guard-bundler'
  gem 'guard-pow'
  gem 'capistrano', '~> 2.13'
  gem 'capistrano-unicorn', :require => false
  gem 'capistrano-shared_file'
  gem 'capistrano_colors'
  gem 'capistrano_rsync_with_remote_cache'
  gem 'rvm-capistrano'
end

group :test do
  gem 'shoulda-matchers'
  gem 'database_cleaner'
  gem 'vcr', '~> 2'
  gem 'webmock'
  gem "fakefs", :require => "fakefs/safe"
end
