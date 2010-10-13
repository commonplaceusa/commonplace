class Neighborhood < ActiveRecord::Base
  has_many :users
  belongs_to :community

  has_many :notifications, :as => :notified

  def self.find_for(address)
    self.all.find { |n| n.contains?(address) }
  end

  def contains?(address)
    bounds.contains?(address)
  end

  def posts
    users.map(&:posts).flatten
  end
  
  private
  
  def bounds
    Geokit::Bounds.new(Geokit::LatLng.new(self.south_bound, self.west_bound),
                       Geokit::LatLng.new(self.north_bound, self.east_bound))
  end

end
