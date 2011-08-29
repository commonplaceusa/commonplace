source :gemcutter

gem 'rails' 
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
gem 'jslint_on_rails', :require => false #! will run before deployments
gem 'kumade' # easy deployment to heroku

# Authentication
gem 'authlogic' # will be replaced with devise
gem 'oauth2'  # will be replaced with devise
gem 'authlogic_oauth2', ">= 1.1.6", :git => "git://github.com/commonplaceusa/authlogic_oauth2.git" # will be replaced with devise
gem 'ezcrypto' # will be replaced with devise
gem 'uuid' # used in app/controllers/admin_controller.rb, could be refactored/removed?

# Authorization
gem 'cancan' # Authorization, see app/models/ability.rb, should be refactored/redone

# Assets
gem 'aws-s3', :require => 'aws/s3' # storing avatars and stuff
gem 'jammit' # compiling assets
gem 'jammit-s3' #! will be used to store compiled assets on s3

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
gem 'compass', '~> 0' # used for stylesheet helpers
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

# Misc
gem 'json' # isn't json built-in?
gem 'system_timer', :platforms => [:ruby_18] # this is annoying
gem 'heroku' # access heroku api

group :development, :test do
  gem 'factory_girl' # we use factory_girl to generate models for tests
  gem 'forgery' # we use forgery to generate data for tests
  gem 'foreman' # we use foreman to start all the processes we need for development
end

group :test do
  gem 'rspec-rails', "~> 2.6" # we use rspec-rails for tests
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
