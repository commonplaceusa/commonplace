class OrganizerDataPoint < ActiveRecord::Base
  include Geokit::Geocoders

  def community
    User.find(self.organizer_id).community
  end

  def generate_point
    if self.attempted_geolocating or (self.lat.present? and self.lng.present?)
      if self.attempted_geolocating and not self.lat.present?
        return
      end
    else
      self.attempted_geolocating = true
      loc = MultiGeocoder.geocode(self.address)
      self.lat = loc.lat
      self.lng = loc.lng
      self.save
    end
  end

end
