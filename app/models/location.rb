class Location < ActiveRecord::Base
  
  belongs_to :locatable, :polymorphic => true

  before_save :update_lat_and_lng

  validates_presence_of :street_address, :zip_code

  def update_lat_and_lng
    if street_address_changed?
      location = Geokit::Geocoders::GoogleGeocoder.geocode("#{street_address}, #{zip_code}")
      if location && location.success?
        write_attribute(:lat,location.lat)
        write_attribute(:lng, location.lng)
      end    
    end
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
    (low_y...high_y).include?(lng)
  end

  def ray_crosses_line_segment?(a,b)
    lat < ((b.first - a.first) * (lng - a.last) /
           (b.last   - a.last  ) + a.first)
  end

  def outside_bounding_box?(s,n,e,w)
    lat < e || w < lat ||
    lng < s || n < lng
  end

  

end
