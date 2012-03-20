Contacts::configure({
  :yahoo => {
    :consumer_key => ENV['yahoo_consumer_key'] || "dj0yJmk9UnFCMnUyU3ZHRk9pJmQ9WVdrOVZtOUpXbkpZTnpnbWNHbzlNVFV3TWpneU9UWXkmcz1jb25zdW1lcnNlY3JldCZ4PThj",
    :consumer_secret => ENV['yahoo_consumer_secret'] || "5b4a031a3f29b3a53428601d8eb9fe13ba8b373f"
  },
  :windows_live => {
    :application_id => ENV['windows_live_application_id'] || "000000004409576D",
    :secret_key => ENV['windows_live_secret_key'] || "K6d0E1QFmIhruormwKKZ8t9xhsUbK8hF",
    :privacy_policy_url => "http://www.ourcommonplace.com/"
  }
})
