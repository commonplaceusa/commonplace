begin
  Contacts::configure({
    :yahoo => {
      :consumer_key => ENV['yahoo_consumer_key'] || "**removed**",
      :consumer_secret => ENV['yahoo_consumer_secret'] || "**removed**"
    },
    :windows_live => {
      :application_id => ENV['windows_live_application_id'] || "**removed**",
      :secret_key => ENV['windows_live_secret_key'] || "**removed**",
      :privacy_policy_url => "http://www.ourcommonplace.com/"
    }
  })
rescue
  puts "Could not initialize Contacts gem"
end
