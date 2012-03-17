Contacts::configure({
  :yahoo => {
    :consumer_key => ENV['yahoo_api_consumer_key'] || "***REMOVED***",
    :consumer_secret => ENV['yahoo_api_consumer_secret'] || "***REMOVED***"
  }
})
