source "http://rubygems.org"
source "http://gems.github.com"

ruby '2.1.5'

gem 'rails', "= 3.2.11"
gem 'sass-rails'
gem "sprockets", ">= 2.2.2"

# API
gem 'sinatra', "= 1.2.7"
gem 'rack-contrib', '= 1.1.0'
gem 'rack-cache', '= 1.2' # For caching
gem 'dalli', '= 1.1.5' # memcache client, for caching
gem 'acts_as_api', '= 0.3.11'
gem 'barometer', '= 0.8.0' #for weather forecasts
gem "compass-rails"

# ActiveRecord
gem 'sunspot_rails', "= 1.3.0"
gem 'sunspot_solr', '= 1.3.0'
gem 'pg', '= 0.13.2' # for postgres
gem 'permanent_records', '= 2.1.2' # adds soft-delete if a model has a deleted_at column
gem 'cocaine', '= 0.3.2'
gem 'paperclip', "= 2.4.5" # we use this to store avatars
gem 'rmagick', '~> 2.15.4'
gem 'geocoder', '= 1.0.5' # we use geocoder to find user latlngs from addresses
gem 'glebm-geokit', '= 1.5.2', :require => 'geokit' # use this to find latlngs from address again. try to remove in favor of geocoder

# MongoDB
gem 'bson_ext'
gem 'mongo_mapper', '= 0.11.0' # used to represent site visits

# Deployment
gem 'thin', '= 1.3.1' # lighter than mongrel, faster than webrick

# Authentication
gem 'devise', '= 2.0.5' # used for authentication
gem 'omniauth', '= 1.0.3' # used for authentication with facebook
gem 'omniauth-facebook', '= 1.2.0' # Facebook strategy for OmniAuth

# Authorization
gem 'cancan', '= 1.6.7' # Authorization, see app/models/ability.rb, should be refactored/redone

# Assets
gem 'aws-s3', :require => 'aws/s3' # storing avatars and stuff
gem 'amazon-ec2', '= 0.9.17', :require => 'AWS' # managing instances

# Worker Jobs
# gem 'mock_redis', :git => "https://github.com/causes/mock_redis.git", :ref => "fe01880"
gem 'redis', '= 2.2.2' # for queueing with resque
gem 'redis-namespace', '= 1.0.3', :require => false # resque wants it, we don't need to require it
gem 'mcbean' # We use this to pull data from rss feeds for import
gem 'loofah'
gem 'nokogiri'
gem 'redcarpet', "= 2.0.1" # We use this to format user messages in emails

# Jobs
gem 'resque', "= 1.19.0" # use this to queue worker processes
gem 'resque-scheduler', '= 1.9.9' # we use this to queue jobs at specific times
gem 'resque-cleaner', '= 0.2.7'

# Mail
gem 'mail'
gem 'mustache', '= 0.99.4' # used for mail
gem 'premailer', '= 1.7.3' # we use this to inline css in our emails

# ActionView
gem 'sanitize', '= 2.0.3' # used in app/controllers/posts_controller.rb (which is dead code) ! remove
gem 'haml'
gem 'formtastic', '= 2.0.2' # used for view templates
gem 'sass', "= 3.2.19"

# Admin
gem 'rails_admin', :git => 'https://github.com/sferik/rails_admin.git', :ref => "1eda06e"
gem 'rest-client', '= 1.6.7'
gem 'leftronic', :git => 'https://github.com/Jberlinsky/leftronic-gem.git', :ref => "a090bf1d49004f501c9164d5dcd51761b48803e4"


# Tech admin
gem 'newrelic_rpm'
gem 'honeybadger'
gem 'resque-honeybadger'

# Monitoring
gem 'airbrake', '= 3.1.2'
gem 'guardrail_notifier', '= 0.2.12' # catch validation errors

# Contacts
gem 'hpricot', '= 0.8.6'
gem 'turing-contacts', :git => "https://github.com/turingstudio/contacts.git", :ref => "aa86d2f", :require => 'contacts'

# Misc
gem 'json', "= 1.6.6" # isn't json built-in?
gem 'heroku', '= 2.28.7' # access heroku api
gem 'rack-timeout', '= 0.0.3' # Timeout requests that take too long
gem 'require_all', '= 1.2.1' # require all ruby files in a directory

# Analytics
gem 'km', '= 1.1.2'
gem 'km-db', :git => "https://github.com/Jberlinsky/km-db.git", :ref => "65bf2c5ffc203a773c9cc2d491306924a6c78cd2"

group :assets do
  gem 'uglifier'
end

group :development do
  gem 'heroku_san', :git => "https://github.com/Jberlinsky/heroku_san.git", :ref => "3ad7d89" # some nice additions to the Heroku gem
end

group :development, :test, :remote_worker do
  gem 'pry', '= 0.9.11.4'
  gem 'colored', '= 1.2'
  gem 'deadweight', '= 0.2.1', :require => 'deadweight/hijack/rails'

  gem 'factory_girl', '= 2.6.3' # we use factory_girl to generate models for tests
  gem 'forgery', '= 0.5.0' # we use forgery to generate data for tests
  gem 'foreman', '= 0.40.0' # we use foreman to start all the processes we need for development
  # gem 'therubyracer'
  gem 'simplecov', '= 0.6.4', :require => false
  gem 'selenium', '= 0.2.5'
  gem 'trollop', '= 1.16.2'
  gem 'brakeman', '= 1.8.2'
end

group :test do
  gem "capybara-screenshot"
  gem "resque_spec"
  gem "rspec-mocks"
  gem "rspec-rails", "~> 3.2.1"
  gem 'spork', '= 0.9.2'
  gem 'capybara'
  gem 'launchy', '= 2.1.0' # we use launchy to launch a browser during integration testing
  gem 'database_cleaner'
end

gem 'rb-readline', '= 0.4.2'
gem 'acts-as-taggable-on', '= 2.3.1'
gem 'amatch', '= 0.2.10'

gem 'builder', '= 3.0.0'
gem 'i18n'
gem 'journey', :git => "git://github.com/Jberlinsky/journey.git", :ref => "v1.0.3-shim"# :ref => "cd6aa3e"
gem 'multi_json', '= 1.2.0'
gem 'rack', '= 1.4.5'
gem 'rack-ssl', '= 1.3.2'
gem 'rack-test', '= 0.6.1'
gem 'rake', '= 0.9.2.2'
gem 'treetop', '= 1.4.10'
gem 'tzinfo', '= 0.3.32'
gem 'area', '= 0.9.0', :require => false
gem 'iconv'
