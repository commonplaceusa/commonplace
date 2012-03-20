Contacts::configure({
  :yahoo => {
    :consumer_key => ENV['yahoo_consumer_key'] || "***REMOVED***",
    :consumer_secret => ENV['yahoo_consumer_secret'] || "***REMOVED***"
  },
  :windows_live => {
    :application_id => ENV['windows_live_application_id'] || "***REMOVED***",
    :secret_key => ENV['windows_live_secret_key'] || "***REMOVED***",
    :privacy_policy_url => "http://www.ourcommonplace.com/"
  }
})
