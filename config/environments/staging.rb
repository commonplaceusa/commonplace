Commonplace::Application.configure do

  config.action_mailer.delivery_method = :smtp
  
  config.cache_classes = true
  
  # Full error reports are disabled and caching is turned on
  config.action_controller.consider_all_requests_local = false
  config.action_controller.perform_caching             = true
  config.log_level = :debug
  
  
end
