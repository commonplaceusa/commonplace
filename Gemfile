source "http://rubygems.org"
source "http://gems.github.com"

gem 'rails', "~> 3.2.0"
gem 'sass-rails'

# API
gem 'sinatra', "~> 1.2.7"
gem 'rack-contrib'
gem 'rack-cache' # For caching
gem 'dalli' # memcache client, for caching
gem 'acts_as_api'
gem 'barometer' #for weather forecasts

# ActiveRecord
gem 'sunspot_rails', "1.3.0"
gem 'sunspot_solr'
gem 'pg' # for postgres
gem 'permanent_records' # adds soft-delete if a model has a deleted_at column
gem 'paperclip', "~> 2.4.4" # we use this to store avatars
gem 'rmagick' # we use this to crop avatars
gem 'geocoder', '~> 1.0.5' # we use geocoder to find user latlngs from addresses
gem 'glebm-geokit', :require => 'geokit' # use this to find latlngs from address again. try to remove in favor of geocoder

# MongoDB
gem 'bson_ext'
gem 'mongo_mapper' # used to represent site visits
gem 'embedded-mongo', :git => "https://github.com/gdb/embedded-mongo.git"

# Deployment
gem 'thin' # lighter than mongrel, faster than webrick
gem 'unicorn' # Magical unicorns are going to help with our concurrency issues

# Authentication
gem 'devise' # used for authentication
gem 'omniauth' # used for authentication with facebook
gem 'omniauth-facebook' # Facebook strategy for OmniAuth

# Authorization
gem 'cancan' # Authorization, see app/models/ability.rb, should be refactored/redone

# Assets
gem 'aws-s3', :require => 'aws/s3' # storing avatars and stuff
gem 'amazon-ec2', :require => 'AWS' # managing instances

# Worker Jobs
gem 'mock_redis', :git => "https://github.com/causes/mock_redis.git"
gem 'redis' # for queueing with resque
gem 'redis-namespace', :require => false # resque wants it, we don't need to require it
gem 'mcbean' # We use this to pull data from rss feeds for import
gem 'redcarpet', "~> 2.0.1" # We use this to format user messages in emails

# Jobs
gem 'resque', "~> 1.19.0" # use this to queue worker processes
gem 'resque-exceptional' # we use this to send notify of exceptions with worker processes
gem 'resque-scheduler' # we use this to queue jobs at specific times
gem 'resque-cleaner'
gem 'resque-job-stats', :git => "https://github.com/alanpeabody/resque-job-stats.git"
gem 'hirefireapp' # auto-scale web and worker processes
# gem "resque-statsd", :git => "https://github.com/cloudability/resque-statsd.git"

# Mail
gem 'mail' # Used for mail
gem 'mustache' # used for mail
gem 'premailer' # we use this to inline css in our emails

# ActionView
gem 'sanitize' # used in app/controllers/posts_controller.rb (which is dead code) ! remove
gem 'haml', '~> 3.1' # used for view templates
gem 'formtastic', '= 2.0.2' # used for view templates
gem 'sass' # used for stylesheets

# Admin
gem 'rails_admin', :git => 'https://github.com/sferik/rails_admin.git'
gem 'googlecharts' # used for admin/overview
gem 'garb' # used to access the Google Analytics API
gem 'rest-client', '>=1.6.1'
gem 'leftronic', :git => 'https://github.com/Jberlinsky/leftronic-gem.git', :ref => "a090bf1d49004f501c9164d5dcd51761b48803e4"

# Tech admin
gem 'newrelic_rpm'

# Monitoring
gem 'exceptional' # we use this to notify on exceptions
gem 'airbrake'
gem 'guardrail_notifier' # catch validation errors

# Features
gem 'rollout' # we use this to control features

# Contacts
gem 'hpricot'
gem 'turing-contacts', :git => "https://github.com/turingstudio/contacts.git", :require => 'contacts'

# Data Export
gem 'simple_xlsx_writer', :require => false

# Misc
gem 'json', "~> 1.6.0" # isn't json built-in?
gem 'system_timer', :platforms => [:ruby_18] # this is annoying
gem 'heroku' # access heroku api
gem 'heroku_san', :git => "https://github.com/Jberlinsky/heroku_san.git" # some nice additions to the Heroku gem
gem 'rack-timeout' # Timeout requests that take too long
gem 'require_all', '~> 1.2.1' # require all ruby files in a directory

# Analytics
gem 'km'
gem 'km-db', :git => "https://github.com/Jberlinsky/km-db.git", :ref => "deb999f1a06a71afb5b4a381bc81f34cc27dcc0b"
gem 'mysql2'

group :assets do
  gem 'uglifier'
  gem 'compass', '0.12.alpha.0'
end

group :development do
  gem 'taps', :git => 'https://github.com/dabio/taps.git'
  # gem 'jammit'
end

group :development, :test, :remote_worker do
  gem 'guard-jslint-on-rails'
  gem 'guard-rails-assets'
  gem 'guard-rspec'
  gem 'guard-sass'
  gem 'colored'
  gem 'deadweight', :require => 'deadweight/hijack/rails'

  #gem 'rails-dev-tweaks', '~> 0.5.2' # Don't reload the code when serving assets
  gem 'factory_girl' # we use factory_girl to generate models for tests
  gem 'forgery' # we use forgery to generate data for tests
  gem 'foreman' # we use foreman to start all the processes we need for development
  gem 'guard' # because doing things manually is for suckers
  gem 'guard-rspec'
  gem 'guard-spork'
  gem 'guard-bundler'
  gem 'therubyracer' # because something was yelling at us for not having a javascript runtime
  gem 'cucumber'
  gem 'simplecov', :require => false
  gem 'cucumber-rails'
  gem 'selenium'
  gem 'trollop'
  #gem 'capybara-webkit'
  #gem 'progress_bar'
end

group :linux do
  gem 'libnotify'
  gem 'rb-inotify'
end

group :osx do
  #gem 'rb-fsevent'
  #gem 'growl_notify'
end

group :test do
  gem 'resque_spec'
  gem 'rspec-rails' # we use rspec-rails for tests
  gem 'vcr'
  gem 'fuubar' # we use fuubar for pretty rspec output
  gem 'spork' # we use spork to speed up tests
  gem 'rr' # we use rr for mocking
  gem 'rspec-rr' # we use rspec-rr for integration between rspec and rr
  gem 'capybara', '1.1.2'
  gem 'launchy' # we use launchy to launch a browser during integration testing
  gem 'database_cleaner' # we use database_cleaner to clean the database between tests
  gem 'jasmine' # we use jasmine for javascript tests
end

gem 'rb-readline'
gem 'acts-as-taggable-on', '~> 2.3.1'
gem 'amatch'
gem 'pry'
