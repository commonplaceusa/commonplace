class AddressGeolocator

  def self.perform
    OrganizerDataPoint.all.map &:generate_point
  end
end
