class EventSender
  def initialize(queuer = Resque)
    @queuer = queuer
  end

  def self.send_event(event_type, options = {})
    #uuid = Guid.new.to_s.gsub("-","")
    #event = { :_type => event_type }.to_json
    #Resque.redis.lpush("fnordmetric-queue", uuid)
    #Resque.redis.set("fnordmetric-event-#{uuid}", event)
    #Resque.redis.expire("fnordmetric-event-#{uuid}", 60)
    event = { :_type => event_type }.merge(options).to_json
    `echo '#{event}' | nc 107.20.208.98 1337`
  end

  def self.user_visited_main_page
    EventSender.send_event("user_signed_in")
  end
end
