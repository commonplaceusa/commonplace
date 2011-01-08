class EventfulImporter
  require 'rubygems'
  require 'eventful/api'

  def self.import_event(event,community)
    if event.is_a?(Array)
      return
    end
    begin
      e = Event.new()
      if !event || event.nil?
        return
      end

      required_keys = ['title', 'description', 'start_time', 'postal_code', 'venue_address', 'id']
      required_keys.each do |key|
        if !event[key].present?
          return
        end
      end
      if Event.find_by_source_feed_id(event['id'])
        return
      end

      location = Location.new(:zip_code => event['postal_code'], :street_address => event['venue_address'])

      e.name = event['title']

      mccbean = McBean.fragment event['description']
      e.description = mccbean.to_html

      e.date = event['start_time'].split(" ")[0]
      e.start_time = event['start_time']
      e.end_time = event['stop_time']

      e.location = location

      # Instead of using one Feed for all Eventful events for a given community, make each result its own Feed
      e.owner_id = Feed.find_or_create_by_name_and_website_and_community_id("Eventful", "http://www.eventful.com/", community).id
      e.owner_type = "Feed"
      e.source_feed_id = event['id']
      e.save!
      puts "Saved"
    rescue TypeError => e
      puts "Failed with TypeError on Community with zipcode #{community.zip_code}!"

    end
  end

  def self.perform
    eventful = Eventful::API.new CONFIG['eventful_application_key'],
    :user => CONFIG['eventful_username'],
    :password => CONFIG['eventful_password']

    Community.find(:all).each do |community|
      results = eventful.call 'events/search',
      :location => community.zip_code,
      :page_size => 10,
      :mature => 'safe'
      # if results['events'].length == 1
      #   results['events'] = ['event' => results['events']]
      # end
      if results['events'].nil? then
        next
      end
      #if results['events'].length == 1
      # self.import_event(results['events']['event'],community.zip_code)
      #else
      results['events']['event'].each do |event|
        self.import_event(event,community)
      end
      #end
    end

  end
end