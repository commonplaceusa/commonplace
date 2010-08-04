class Event < ActiveRecord::Base
  
  validates_presence_of :name, :description, :start_time

  has_many :referrals
  has_many :messages, :as => :notify
  has_many :attendances
  has_many :attendees, :through => :attendances, :source => :user
  belongs_to :organization

  before_save :update_lat_and_lng, :if => "address_changed?"

  named_scope :upcoming, :conditions => ["? < start_time", Time.now]
  named_scope :past, :conditions => ["start_time < ?", Time.now]

  has_many :thread_memberships, :as => :thread
  has_many :subscribers, :as => :thread, :through => :thread_memberships
  
  def search(term)
    Event.all
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
