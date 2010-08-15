class Event < ActiveRecord::Base

  require 'lib/helper'
  
  validates_presence_of :name, :description, :start_time

  has_many :referrals
  has_many :messages, :as => :notify
  has_many :attendances
  has_many :attendees, :through => :attendances, :source => :user
  belongs_to :organization

  before_save :update_lat_and_lng, :if => "address_changed?"

  named_scope :upcoming, :conditions => ["? < start_time", Time.now]
  named_scope :past, :conditions => ["start_time < ?", Time.now]

  def replies
    []
  end

  def search(term)
    Event.all
  end

  def time
    help.event_date self.start_time
  end
  
  def subject
    self.name
  end
  
  def body
    self.description
  end
  
  def owner
    self.organization
  end
  
  # Delete this soon!
  def reply_count
    "4&nbsp;replies"
  end

  def update_lat_and_lng
    if address.blank?
      true
    else
      location = Geokit::Geocoders::GoogleGeocoder.geocode(address)
      if location && location.success?
        write_attribute(:lat,location.lat)
        write_attribute(:lng, location.lng)
        write_attribute(:address, location.full_address)
      else
        false
      end
    end
  end
end
