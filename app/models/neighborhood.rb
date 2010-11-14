class Neighborhood < ActiveRecord::Base
  has_many :users
  belongs_to :community

  has_many :notifications, :as => :notified

  serialize :bounds

  def self.find_for(address)
    self.all.find { |n| n.contains?(address) }
  end

  def contains?(location)
    location.within?(bounds)
  end

  def posts
    users.map(&:posts).flatten
  end

end
