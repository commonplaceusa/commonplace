class Forgery::Latlng < Forgery
  
  
  def self.random(options = {})
    if options[:within] && options[:miles_of]
      point = options[:miles_of]
      distance = options[:within]
      
      location = Geocoder::Calculations.to_radians(point)
      
      radius = Geocoder::Calculations.distance_to_radians(distance)
      
      a = 2 * Math::PI * rand(0)
      
      distance_coefficient = Math.sqrt(rand(0))
            
      Geocoder::Calculations.
        to_degrees([radius * distance_coefficient * Math.cos(a) + location.first,
                    radius * distance_coefficient * Math.sin(a) + location.last])
      
    else
      [random_latitude, random_longitude]
    end
  end
  
  private

  def self.random_latitude
    (rand(180) - 90) + rand(0)
  end

  def self.random_longitude
    (rand(360) - 180) + rand(0)
  end

end
