if Rails.env.development?
  begin
    Sunspot::Rails::Server.new.start
  rescue Sunspot::Server::AlreadyRunningError
    puts "Sunspot Solr already running. Carrying on..."
  end
end
