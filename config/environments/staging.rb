# Don't care if the mailer can't send
config.action_mailer.delivery_method = :test

config.cache_classes = true

# Full error reports are disabled and caching is turned on
config.action_controller.consider_all_requests_local = false
config.action_controller.perform_caching             = true
config.action_view.cache_template_loading            = true
config.log_level :debug
