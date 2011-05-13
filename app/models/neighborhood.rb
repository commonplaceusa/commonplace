class Neighborhood < ActiveRecord::Base
  has_many :users

  reverse_geocoded_by :latitude, :longitude

  belongs_to :community

  serialize :bounds, Array
  validates_presence_of :name

  def self.closest_to(location)
    geocoded.near(location, 15).limit(1).first
  end

  def coordinates
    [latitude,longitude]
  end

  def coordinates=(cs)
    self.latitude, self.longitude = *cs
  end

  def contains?(position)
    position.within? self.bounds
  end
end
