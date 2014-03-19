Commonplace::Application.configure do

  # Don't Compress JavaScripts and CSS
  config.assets.compress = true

  # Fallback to assets pipeline if a precompiled asset is missed
  config.assets.compile = true

  # Generate digests for assets URLs
  config.assets.digest = true

  config.action_mailer.delivery_method = :smtp
  
  config.cache_classes = true

  #config.cache_store = :dalli_store
  
  # Full error reports are disabled and caching is turned on
  config.consider_all_requests_local = true

  config.action_controller.perform_caching             = true

  config.log_level = :debug
  
  
end
