class Location < ActiveRecord::Base
  
  belongs_to :locatable, :polymorphic => true

  before_save :update_lat_and_lng

  def update_lat_and_lng
    if street_address_changed?
      location = Geokit::Geocoders::GoogleGeocoder.geocode("#{street_address}, #{zip_code}")
      if location.success?
        write_attribute(:lat,location.lat)
        write_attribute(:lng, location.lng)
      end    
      true  
    end
  end

end
