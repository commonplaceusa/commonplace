class EventfulImporter
  require 'rubygems'
  require 'eventful/api'

  def self.import_event(event,community)
    # The only properly formed input is a Hash
    if event.is_a?(Array)
      return
    end
    
    begin
      e = Event.new()
      if !event || event.nil?
        return
      end

      # Ensure that all necessary fields are present
      required_keys = ['title', 'description', 'start_time', 'postal_code', 'venue_address', 'id']
      required_keys.each do |key|
        if !event[key].present?
          return
        end
      end
      
      # If this event has already been imported, skip it
      if Event.find_by_source_feed_id(event['id'])
        return
      end

      e.name = event['title']

      # Convert from HTML to Markdown
      mccbean = McBean.fragment event['description']
      e.description = mccbean.to_markdown

      e.date = event['start_time'].split(" ")[0]
      e.start_time = event['start_time']
      
      if event['stop_time'].present?
        e.end_time = event['stop_time']
      end

      e.location = Location.new(:zip_code => event['postal_code'], :street_address => event['venue_address'])

      e.owner = Feed.find_or_create_by_name_and_website_and_community_id("Eventful", "http://www.eventful.com/", community.id)
      e.source_feed_id = event['id']
      e.save
    rescue TypeError => e
      puts "Failed with TypeError on Community with zipcode #{community.zip_code}!"
    end
  end

  def self.perform
    eventful = Eventful::API.new $EventfulApplicationKey,
    :user => $EventfulUsername,
    :password => $EventfulPassword

    Community.find(:all).each do |community|
      results = eventful.call 'events/search',
        :location => community.zip_code,
        :page_size => 10,
        :mature => 'safe'
        
      if results['events'].nil? then
        next
      end
      results['events']['event'].each do |event|
        self.import_event(event,community)
      end
    end
  end
end
