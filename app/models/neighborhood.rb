class Neighborhood < ActiveRecord::Base
  has_many :users

  belongs_to :community

  serialize :bounds, Array

  def coordinates
    [latitude,longitude]
  end

  def contains?(position)
    position.within? self.bounds
  end

end
