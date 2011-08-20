if Rails.env.development? or CP_ENV == 'staging'
  begin
    Sunspot::Rails::Server.new.start
  rescue Sunspot::Server::AlreadyRunningError
    puts "Sunspot Solr already running. Carrying on..."
  end
end
