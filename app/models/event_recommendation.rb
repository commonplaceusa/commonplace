class EventRecommendation

  extend ActsAsApi::Base
  
  def model_name
    "event_recommendation"
  end
  
  def initialize(event)
    @event = event
  end

  def title
    @event.name
  end

  def venue 
    @event.venue
  end

  def latitude
    @event.latitude
  end

  def longitude
    @event.longitude
  end

  def id
    @event.id
  end

  def notes
    @event.event_notes
  end

  acts_as_api
  
  api_accessible :default do |t|
    t.add :id
    t.add :title
    t.add :venue
    t.add :links
    t.add :latitude
    t.add :longitude
    t.add :notes
  end

  def links
    { "checkins" => "/events/#{@event.id}/checkins",
      "notes" => "/events/#{@event.id}/notes"
    }
  end
end
