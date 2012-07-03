#!/usr/bin/env ruby
require 'heroku'
require 'trollop'

module Git
  module Remote
    Add = "git remote add"
  end

  Push = "git push"
  Master = "master"
end

def options
  @options ||= Trollop.options do
    opt :user, "User Shortname", :type => String
    opt :email, "E-mail Address", :type => String
  end
end

def heroku
  @heroku ||= Heroku::Client.new('jberlinsky@gmail.com', '601845')
end

def app_name
  @app_name ||= "commonplace-staging-#{user}"
  @app_name
end

def user
  Trollop::die :user, "must be defined" unless options[:user]
  options[:user]
end

def email
  Trollop::die :email, "must be defined" unless options[:email]
  options[:email]
end

def execute_command(command)
  puts "METHOD DEPRECATED: Please find another way to execute '#{command}'"
  `#{command}`
end

def addons
  {
    'releases' => nil,
    'redistogo' => 'nano',
    'memcache' => '5mb',
    'custom_error_pages' => nil,
    'cron' => 'daily',
    'pgbackups' => nil,
    'mongolab' => 'starter'
  }
end

def labs
  [
    'user_env_compile'
  ]
end

def environment
  [
    ['ERROR_PAGE_URL', 'https://s3.amazonaws.com/commonplace-heroku-pages/maintenance.html'],
    ['S3_KEY_ID', '***REMOVED***'],
    ['S3_KEY_SECRET', '***REMOVED***'],
    ['facebook_app_id', '***REMOVED***'],
    ['facebook_app_secret', '***REMOVED***'],
    ['facebook_password', 'staging'],
    ['facebook_salt', '***REMOVED***'],
    ['BUNDLE_WITHOUT', 'development:test:osx:remote_worker'],
    ['RAILS_ENV', 'staging']
  ]
end

def rake_tasks
  [
    'sunspot:reindex'
  ]
end

def heroku_tasks
  {
    'pgbackups:restore' => [
      'DATABASE',
      execute_command('heroku pgbackups:url --app commonplace')
    ]
  }
end

def share_with
  [
    email
  ]
end

def git_remotes
  [
    [
      "staging-#{user}", "git@heroku.com:#{app_name}.git"
    ]
  ]
end

time_started = Time.now

puts "Creating '#{app_name}'"
heroku.create(app_name)

addons.each do |addon|
  execute_command("bundle exec heroku addons:add #{Array(addon.compact).join(':')} --app #{app_name}")
end

labs.each do |lab|
  execute_command("heroku labs:enable user_env_compile --app #{app_name}")
end

environment.each do |env|
  execute_command "bundle exec heroku config:add #{env.first}=#{env.last} --app #{app_name}"
end

git_remotes.each do |remote|
  execute_command([Git::Remote::Add, remote[0], remote[1]].join(' '))
  execute_command([Git::Push, remote[0], Git::Master].join(' '))
end

execute_command "bundle exec heroku addons:add pgbackups --app #{app_name}"

execute_command "bundle exec heroku sharing:add #{email} --app #{app_name}"

execute_command "bundle exec heroku config:add RAILS_ENV=staging --app #{app_name}"
execute_command "bundle exec heroku restart --app #{app_name}"
execute_command "bundle exec heroku run rake assets:precompile --app #{app_name}"

execute_command "bundle exec heroku maintenance:off --app #{app_name}"

execute_command "heroku pg:reset SHARED_DATABASE --app #{app_name} --confirm #{app_name}"
execute_command "heroku run rake db:setup --app #{app_name}"
execute_command "bundle exec heroku pgbackups:restore DATABASE `bundle exec heroku pgbackups:url --app commonplace` --app #{app_name} --confirm #{app_name}"

time_elapsed = Time.now - time_started

puts "Took #{time_elapsed / 60} minutes!"
