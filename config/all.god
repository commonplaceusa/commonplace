PID_DIR       = '/srv/commonplace/shared/pids'
RAILS_ENV     = ENV['RAILS_ENV'] = 'production'
RAILS_ROOT    = ENV['RAILS_ROOT'] = '/home/deploy/commonplace/current'
BIN_PATH      = "/usr/local/bin"

God.log_file  = "#{RAILS_ROOT}/log/god.log"
God.log_level = :info

%w(unicorn).each do |config|
  God.load "#{RAILS_ROOT}/config/god/#{config}.god"
end
