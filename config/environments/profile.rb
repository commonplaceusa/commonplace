require 'production_log/syslog_logger'
Commonplace::Application.configure do
  config.cache_classes = true

  config.action_controller.perform_caching             = false
  config.log_level = :info
  RAILS_DEFAULT_LOGGER = SyslogLogger.new
end
