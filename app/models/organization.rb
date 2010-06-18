class Organization < ActiveRecord::Base

  acts_as_taggable_on :interests

  validates_presence_of :name

  has_many :sponsorships
  has_many :events, :through => :sponsorships

  has_many :text_modules, :order => "position"

  has_attached_file(:avatar, :styles => { :thumb => "100x100" })

  
  before_save :update_lat_and_lng, :if => "address_changed?"

  # TODO: pull this out into a module
  def update_lat_and_lng
    unless address.blank?
      location = Geokit::Geocoders::GoogleGeocoder.geocode(address)
      if location.success?
        write_attribute(:lat,location.lat)
        write_attribute(:long, location.lng)
        write_attribute(:address, location.full_address)
      end    
      true  
    end
  end
end
