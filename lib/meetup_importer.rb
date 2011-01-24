class MeetupImporter
  require 'rubygems'
  require 'rmeetup'
  
  def self.perform
    RMeetup::Client.api_key = CONFIG['meetup_api_key']

    Community.find(:all).each do |community|
      results = RMeetup::Client.fetch(:events,{:zip => community.zip_code, :text_format => "html"})
      results.each do |event|
        e = MeetupEvent.new
        e.host_group_name = event.group_name.toutf8
        e.name            = event.name.toutf8
        e.date            = event.time.strftime('%Y-%m-%d')
        e.start_time      = event.time
        e.address         = event.venue_address1.toutf8 + " " + event.venue_address2.toutf8 + ", " + event.venue_city.toutf8 + " " + event.venue_state.toutf8 + " " + event.venue_zip.toutf8
        e.venue           = event.venue_name.toutf8
        e.owner = Feed.find_or_create_by_name_and_website_and_community_id("Meetup", event.event_url, community.id)
        e.source_feed_id = event.id
        # Convert from HTML to Markdown
        mccbean = McBean.fragment event.description.toutf8
        e.description = mccbean.to_markdown
        
        # Save away!
        if e.description.present? && !Event.find_by_source_feed_id(event.id.to_s)
          e.save!
        end
      end
    end
  end
end
