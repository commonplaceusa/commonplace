class EventNote < ActiveRecord::Base

  extend ActsAsApi::Base

  def model_name
    "event_note"
  end

  belongs_to :user
  belongs_to :event
  
  def author
    user.name
  end

  acts_as_api

  api_accessible :default do |t|
    t.add :body
    t.add :author
    t.add :created_at, :as => :timestamp
  end
  
end
