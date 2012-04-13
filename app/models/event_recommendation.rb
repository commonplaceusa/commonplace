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

  acts_as_api
  
  api_accessible :default do |t|
    t.add :title
    t.add :venue
  end

end
