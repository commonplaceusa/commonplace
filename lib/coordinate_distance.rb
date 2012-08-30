module CoordinateDistance
  R = 6371

  def self.to_radian(number)
    number * Math::PI / 180
  end

  def self.distance(source, destination)
    delta_latitude = to_radian(destination.latitude - source.latitude)
    delta_longitude = to_radian(destination.longitude - source.longitude)
    source_latitude = to_radian(source.latitude)
    destination_latitude = to_radian(destination.latitude)

    a = Math.sin(delta_latitude / 2) * Math.sin(delta_latitude / 2) +
      Math.sin(delta_longitude / 2) * Math.sin(delta_longitude / 2) * Math.cos(source_latitude) *
      Math.cos(destination_latitude)
    c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a))
    R * c
  end

  # This is where one specifies the cut-off [in km] for whether or not
  # one's location is within a given town.
  def self.cutoff(town)
    name = town[:slug]
    distance = town[:distance]
    case name
    when "Warwick", "Clarkston"
      return distance > 2
    when "Belmont", "Watertown"
      return distance > 3
    when "Falls Church"
      return distance > 3.5
    when "Vienna", "Owosso/Corunna", "Lexington"
      return distance > 5
    when "Chelmsford"
      return distance > 6
    when "Golden Valley", "Burnsville", "Concord"
      return distance > 8
    when "Harrisonburg", "Marquette"
      return distance > 10
    when "Fayetteville"
      return distance > 12
    else
      return true
    end
  end

=begin
  def self.distance(source, destination)
    a = (destination.latitude - source.latitude).abs
    b = (destination.longitude - source.longitude).abs
    Math.sqrt(a*a + b*b)
  end
=end
end
