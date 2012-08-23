module CoordinateDistance
  # R = 6371

  # def self.to_radian(number)
    # number * Math::PI / 180
  # end

  # def self.distance(source, destination)
    # delta_latitude = to_radian(destination.latitude - source.longitude)
    # delta_longitude = to_radian(destination.longitude - source.longitude)
    # source_latitude = to_radian(source.latitude)
    # destination_latitude = to_radian(source.latitude)

    # a = Math.sin(delta_latitude / 2) * Math.sin(delta_latitude / 2) +
      # Math.sin(delta_longitude / 2) * Math.sin(delta_longitude / 2) * Math.cos(source_latitude) *
      # Math.cos(destination_latitude)
    # c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a))
    # R * c
  # end

  def self.distance(source, destination)
    a = (destination.latitude - source.latitude).abs
    b = (destination.longitude - source.longitude).abs
    Math.sqrt(a*a + b*b)
  end
end
