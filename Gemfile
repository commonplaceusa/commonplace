source :gemcutter

gem 'rails', "~> 3.1.0"
gem 'rack' 

# API
gem 'sinatra' # Powers the api
gem 'sham_rack' # For using the api in-process
gem 'faraday' # For using the api in-process
gem 'rack-cache' # For caching
gem 'dalli' # memcache client, for caching

# ActiveRecord
gem 'sunspot_rails' # database search
gem 'pg' # for postgres
gem 'permanent_records' # adds soft-delete if a model has a deleted_at column
gem 'paperclip' # we use this to store avatars
gem 'rmagick' # we use this to crop avatars
gem 'geocoder' # we use geocoder to find user latlngs from addresses

# Deployment
gem 'thin' # lighter than mongrel, faster than webrick

# Authentication
gem 'devise' # used for authentication
gem 'uuid' # used in app/controllers/admin_controller.rb, could be refactored/removed?

# Authorization
gem 'cancan' # Authorization, see app/models/ability.rb, should be refactored/redone

# Assets
gem 'aws-s3', :require => 'aws/s3' # storing avatars and stuff

# Worker Jobs
gem 'redis' # for queueing with resque 
gem 'redis-namespace', :require => false # resque wants it, we don't need to require it
gem 'mcbean' # We use this to pull data from rss feeds for import
gem 'BlueCloth', :require => 'bluecloth' # we use this in our views and mailers

# ActiveRecord
gem 'paperclip' # we use this to store avatars
gem 'rmagick' # we use this to crop avatars
gem 'geocoder' # we use geocoder to find user latlngs from addresses
gem 'glebm-geokit', :require => 'geokit' # use this to find latlngs from address again. try to remove in favor of geocoder

# Jobs
gem 'resque' # use this to queue worker processes
gem 'resque-exceptional' # we use this to send notify of exceptions with worker processes
gem 'resque-scheduler' # we use this to queue jobs at specific times
gem 'hirefireapp' # auto-scale web and worker processes
gem 'delayed_job' # we use this to run jobs to index our data

# Mail
gem 'mail' # Used for mail
gem 'mustache' # used for mail
gem 'premailer' # we use this to inline css in our emails

# ActionView
gem 'sanitize' # used in app/controllers/posts_controller.rb (which is dead code) ! remove
gem 'haml', '~> 3.1' # used for view templates
gem 'formtastic' # used for view templates
gem 'sass', '~> 3.1' # used for stylesheets
gem 'BlueCloth', :require => 'bluecloth' # we use this in our views and mailers

# Admin
gem 'activeadmin' # use as an easy admin tool
gem 'googlecharts' # used for admin/overview

# Monitoring
gem 'exceptional' # we use this to notify on exceptions
gem 'rpm_contrib' # we use this to monitor the app
gem 'newrelic_rpm' # we use this to monitor the app

# Features
gem 'rollout' # we use this to control features

# Tagging
gem 'acts-as-taggable-on', '~> 2.1.0'

# Misc
gem 'json' # isn't json built-in?
gem 'system_timer', :platforms => [:ruby_18] # this is annoying
gem 'heroku' # access heroku api


group :assets do
  gem 'sass-rails', "  ~> 3.1.0"
  gem 'coffee-rails', "~> 3.1.0"
  gem 'uglifier'
  gem 'compass', :git => 'git://github.com/chriseppstein/compass.git', :branch => 'rails31'
end

group :development, :test do
  gem 'libnotify'
  gem 'rb-inotify'
  gem 'guard-jslint-on-rails'
  gem 'rails-dev-tweaks', '~> 0.5.0' # Don't reload the code when serving assets
  gem 'factory_girl' # we use factory_girl to generate models for tests
  gem 'forgery' # we use forgery to generate data for tests
  gem 'foreman' # we use foreman to start all the processes we need for development
  gem 'pry' # for when IRB is not enough
  gem 'guard' # because doing things manually is for suckers
  gem 'guard-bundler'
end

group :test do
  gem 'rspec-rails' # we use rspec-rails for tests
  gem 'fuubar' # we use fuubar for pretty rspec output
  gem 'spork' # we use spork to speed up tests
  gem 'rr' # we use rr for mocking
  gem 'rspec-rr' # we use rspec-rr for integration between rspec and rr
  gem 'webmock' # we use webmock to mock google maps and other apis
  gem 'capybara', :git => 'git://github.com/jnicklas/capybara.git' # we use capybara for integration testing
  gem 'launchy' # we use launchy to launch a browser during integration testing 
  gem 'database_cleaner' # we use database_cleaner to clean the database between tests
  gem 'autotest-standalone' # we use autotest to run tests when files change
  gem 'autotest-rails-pure' # we use autotest to run tests when files change
  gem 'jasmine' # we use jasmine for javascript tests
end
