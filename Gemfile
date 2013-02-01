source "http://rubygems.org"
source "http://gems.github.com"

gem 'rails', "= 3.2.10"
gem 'sass-rails', '= 3.2.4'

# API
gem 'sinatra', "= 1.2.7"
gem 'rack-contrib', '= 1.1.0'
gem 'rack-cache', '= 1.2' # For caching
gem 'dalli', '= 1.1.5' # memcache client, for caching
gem 'acts_as_api', '= 0.3.11'
gem 'barometer', '= 0.7.3' #for weather forecasts

# ActiveRecord
gem 'sunspot_rails', "= 1.3.0"
gem 'sunspot_solr', '= 1.3.0'
gem 'pg', '= 0.13.2' # for postgres
gem 'permanent_records', '= 2.1.2' # adds soft-delete if a model has a deleted_at column
gem 'paperclip', "= 2.4.5" # we use this to store avatars
gem 'rmagick', '= 2.13.1' # we use this to crop avatars
gem 'geocoder', '= 1.0.5' # we use geocoder to find user latlngs from addresses
gem 'glebm-geokit', '= 1.5.2', :require => 'geokit' # use this to find latlngs from address again. try to remove in favor of geocoder

# MongoDB
gem 'bson_ext', '= 1.6.1'
gem 'mongo_mapper', '= 0.11.0' # used to represent site visits

# Deployment
gem 'thin', '= 1.3.1' # lighter than mongrel, faster than webrick
# gem 'unicorn' # Magical unicorns are going to help with our concurrency issues

# Authentication
gem 'devise', '= 2.0.4' # used for authentication
gem 'omniauth', '= 1.0.3' # used for authentication with facebook
gem 'omniauth-facebook', '= 1.2.0' # Facebook strategy for OmniAuth

# Authorization
gem 'cancan', '= 1.6.7' # Authorization, see app/models/ability.rb, should be refactored/redone

# Assets
gem 'aws-s3', '= 0.6.2', :require => 'aws/s3' # storing avatars and stuff
gem 'amazon-ec2', '= 0.9.17', :require => 'AWS' # managing instances

# Worker Jobs
gem 'mock_redis', :git => "https://github.com/causes/mock_redis.git", :ref => "fe01880"
gem 'redis', '= 2.2.2' # for queueing with resque
gem 'redis-namespace', '= 1.0.3', :require => false # resque wants it, we don't need to require it
gem 'mcbean', '= 0.4.0' # We use this to pull data from rss feeds for import
gem 'redcarpet', "= 2.0.1" # We use this to format user messages in emails

# Jobs
gem 'resque', "= 1.19.0" # use this to queue worker processes
gem 'resque-scheduler', '= 1.9.9' # we use this to queue jobs at specific times
gem 'resque-cleaner', '= 0.2.7'

# Mail
gem 'mail', '= 2.4.4' # Used for mail
gem 'mustache', '= 0.99.4' # used for mail
gem 'premailer', '= 1.7.3' # we use this to inline css in our emails

# ActionView
gem 'sanitize', '= 2.0.3' # used in app/controllers/posts_controller.rb (which is dead code) ! remove
gem 'haml', '= 3.1.4' # used for view templates
gem 'formtastic', '= 2.0.2' # used for view templates
gem 'sass', '= 3.1.15' # used for stylesheets

# Admin
gem 'rails_admin', :git => 'https://github.com/sferik/rails_admin.git', :ref => "1eda06e"
gem 'rest-client', '= 1.6.7'
gem 'leftronic', :git => 'https://github.com/Jberlinsky/leftronic-gem.git', :ref => "a090bf1d49004f501c9164d5dcd51761b48803e4"

# Tech admin
gem 'newrelic_rpm', '= 3.5.0.1'

# Monitoring
gem 'airbrake', '= 3.1.2'
gem 'guardrail_notifier', '= 0.2.12' # catch validation errors

# Contacts
gem 'hpricot', '= 0.8.6'
gem 'turing-contacts', :git => "https://github.com/turingstudio/contacts.git", :ref => "aa86d2f", :require => 'contacts'

# Misc
gem 'json', "= 1.6.6" # isn't json built-in?
gem 'system_timer', :platforms => [:ruby_18] # this is annoying
gem 'heroku', '= 2.28.7' # access heroku api
gem 'rack-timeout', '= 0.0.3' # Timeout requests that take too long
gem 'require_all', '= 1.2.1' # require all ruby files in a directory

# Analytics
gem 'km', '= 1.1.2'
gem 'km-db', :git => "https://github.com/Jberlinsky/km-db.git", :ref => "1d6ecc6eb3007cb7b78f8352479f4f698660b270"
gem 'mysql2', '= 0.3.11'

group :assets do
  gem 'uglifier', '= 1.2.3'
  gem 'compass', '0.12.alpha.0'
end

group :development do
  gem 'taps', :git => 'https://github.com/dabio/taps.git', :ref => "a56d8e8"
  gem 'heroku_san', :git => "https://github.com/Jberlinsky/heroku_san.git", :ref => "3ad7d89" # some nice additions to the Heroku gem
end

group :development, :test, :remote_worker do
  gem 'pry'
  gem 'colored', '= 1.2'
  gem 'deadweight', '= 0.2.1', :require => 'deadweight/hijack/rails'

  gem 'factory_girl', '= 2.6.3' # we use factory_girl to generate models for tests
  gem 'forgery', '= 0.5.0' # we use forgery to generate data for tests
  gem 'foreman', '0.40.0' # we use foreman to start all the processes we need for development
  gem 'therubyracer', '= 0.9.10' # because something was yelling at us for not having a javascript runtime
  gem 'cucumber', '= 1.1.0'
  gem 'simplecov', '= 0.6.4', :require => false
  gem 'selenium', '= 0.2.5'
  gem 'trollop', '= 1.16.2'
end

group :test do
  gem 'resque_spec', '= 0.12.5'
  gem 'rspec-rails', '= 2.8.1' # we use rspec-rails for tests
  gem 'fuubar', '= 1.0.0' # we use fuubar for pretty rspec output
  gem 'spork', '= 0.9.2'
  gem 'rr', '= 1.0.4'
  gem 'capybara', '1.1.2'
  gem 'launchy', '= 2.1.0' # we use launchy to launch a browser during integration testing
  gem 'database_cleaner', '= 0.7.1' # we use database_cleaner to clean the database between tests
  gem 'jasmine', '= 1.2.1' # we use jasmine for javascript tests
  gem 'cucumber-rails', '= 1.1.1'
end

gem 'rb-readline', '= 0.4.2'
gem 'acts-as-taggable-on', '= 2.3.1'
gem 'amatch', '= 0.2.10'

gem 'builder', '= 3.0.0'
gem 'i18n', '= 0.6.0'
gem 'journey', :git => "git://github.com/Jberlinsky/journey.git", :ref => "v1.0.3-shim"# :ref => "cd6aa3e"
gem 'multi_json', '= 1.2.0'
gem 'rack', '= 1.4.1'
gem 'rack-ssl', '= 1.3.2'
gem 'rack-test', '= 0.6.1'
gem 'rake', '= 0.9.2.2'
gem 'sprockets', '= 2.2.1'
gem 'treetop', '= 1.4.10'
gem 'tzinfo', '= 0.3.32'
