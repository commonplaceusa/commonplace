class EventSender
  @queue = :statistics_events
  def initialize(queuer = Resque)
    @queuer = queuer
  end

  def self.perform(event_object)
    server = ENV['metrics_server'] || 'localhost'
    #RestClient.post "http://#{server}:4242/events", event_object
    event = event_object.to_json
    `echo '#{event}' | nc #{server} 1337`
  end

  def self.send_event(event_type, options = {})
    #uuid = Guid.new.to_s.gsub("-","")
    #event = { :_type => event_type }.to_json
    #Resque.redis.lpush("fnordmetric-queue", uuid)
    #Resque.redis.set("fnordmetric-event-#{uuid}", event)
    #Resque.redis.expire("fnordmetric-event-#{uuid}", 60)
    Resque.enqueue(EventSender, { :_type => event_type }.merge(options))
    #event = { :_type => event_type }.merge(options).to_query
    #server = ENV['metrics_server'] || 'localhost'
    #`echo '#{event}' | nc #{server} 1337`
    #`curl -X POST -d "#{event}" http://#{server}:4242/events`
  end

  def self.user_visited_main_page
    EventSender.send_event("user_signed_in")
  end

  def self.page_view(page_name, session_token)
    EventSender.send_event("_pageview", { :url => page_name, :_session => session_token })
  end

  def self.associate_name(user_name, session_token)
    EventSender.send_event("_set_name", { :name => user_name, :_session => session_token })
  end

  def self.associate_picture(user_picture_url, session_token)
    EventSender.send_event("_set_picture", { :url => user_picture_url, :_session => session_token })
  end
end
