PID_DIR       = '/home/deploy/commonplace/shared/pids'
RAILS_ENV     = ENV['RAILS_ENV'] = 'production'
RAILS_ROOT    = ENV['RAILS_ROOT'] = '/home/deploy/commonplace/current'
BIN_PATH      = "/usr/local/rvm/gems/ree-1.8.7-2010.02/bin"

God.log_file  = "#{RAILS_ROOT}/log/god.log"
God.log_level = :info

%w(unicorn).each do |config|
  God.load "#{RAILS_ROOT}/config/god/#{config}.god"
end
