class Event < ActiveRecord::Base
  
  validates_presence_of :name

  has_many :referrals

  before_save :update_lat_and_lng, :if => "address_changed?"

  named_scope :upcoming, :conditions => ["? < start_time", Time.now]
  named_scope :past, :conditions => ["start_time < ?", Time.now]

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
