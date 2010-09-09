class Mapifier

  def initialize(&block)
    @markers, @directions, @polygons = [],[],[]
    block.call(self)
    self
  end
  
  def center(options)
    @center = {:lat => options[:lat], :lng => options[:lng]}
  end

  def marker(options = {})
    @markers << Marker.new(options)
  end

  def polygon(&block)
    polygon = Polygon.new(&block)
    @polygons << polygon
  end

  def directions(&block)
    directions = Directions.new(&block)
    @directions << directions
  end

  def as_json
    { :markers => @markers.map(&:as_json),
      :polygons => @polygons.map(&:as_json),
      :directions => @directions.map(&:as_json),
      :center => @center.as_json
    }.as_json
  end
  
  def to_json
    as_json.to_json
  end
end

class Marker
  def initialize(options)
    @position= {:lat => options[:lat], :lng => options[:lng]}
  end
  
  def as_json
    {:position => @position}.as_json
  end

end

class Directions
  def initialize(&block)
    block.call(self)
    self
  end

  def destination(latlng)
    @destination = latlng
  end
  
  def origin(latlng)
    @origin = latlng
  end

  def as_json
    { :origin => @origin,
      :destination => @destination
    }.as_json
  end
end

class Polygon
  def initialize(&block)
    @vertices = []
    block.call(self)
    self
  end

  def vertex(options)
    @vertices << {:lat => options[:lat], :lng => options[:lng]}
  end
  
  def as_json
    {:vertices => @vertices.map(&:as_json)}.as_json
  end
end
