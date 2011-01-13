class LatLng

  attr_accessor :lat, :lng
  
  def self.from_address(address, zip_code)
    bias = Geokit::Geocoders::GoogleGeocoder.geocode(zip_code).suggested_bounds
    location = Geokit::Geocoders::GoogleGeocoder.geocode(address, :bias => bias)
    if location && location.success?
      LatLng.new(location.lat,location.lng)
    else
      nil
    end
  end

  def initialize(lat,lng)
    self.lat, self.lng = lat,lng
  end
  
  def within?(bounds)
    return false if outside_bounding_box?(*[bounds.map(&:last).minmax,
                                            bounds.map(&:first).minmax].flatten)
    bounds.each_with_index.count { |point,index|
      previous_point = bounds[index - 1]
      between_ys_of_line_segment?(point, previous_point) &&
        ray_crosses_line_segment?(point, previous_point)
    
    }.odd?
  end
  
  
  private
  
  def between_ys_of_line_segment?(a,b)
    low_y, high_y = [a.last,b.last].sort
    (low_y...high_y).include?(self.lng)
  end

  def ray_crosses_line_segment?(a,b)
    self.lat < ((b.first - a.first) * (self.lng - a.last) /
                (b.last   - a.last  ) + a.first)
  end

  def outside_bounding_box?(s,n,e,w)
    self.lat < e || w < self.lat ||
      self.lng < s || n < self.lng
  end

end
