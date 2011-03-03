class Neighborhood < ActiveRecord::Base
  has_many :users

  belongs_to :community

  serialize :bounds, Array

  validates_presence_of :name, :bounds

  def contains?(position)
    position.within? self.bounds
  end

end
