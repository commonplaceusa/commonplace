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

  acts_as_api
  
  api_accessible :default do |t|
    t.add :title
    t.add :venue
    t.add :links
    t.add :latitude
    t.add :longitude
  end

  def links
    { "checkins" => "/events/#{@event.id}/checkins" }
  end
end
