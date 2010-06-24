class Event < ActiveRecord::Base
  
  validates_presence_of :name

  has_many :attendances
  has_many :users, :through => :attendances
  
  has_many :sponsorships

  has_many :businesses, :through => :sponsorships, :source => :business,
                        :conditions => "sponsorships.sponsor_type = 'Business'"

  has_many :organization, :through => :sponsorships, :source => :organization,
                        :conditions => "sponsorships.sponsor_type = 'Organization'"

  before_save :update_lat_and_lng, :if => "address_changed?"

  named_scope :upcoming, :conditions => ["? < start_time", Time.now]

  def sponsors
    self.businesses + self.organizations
  end

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
