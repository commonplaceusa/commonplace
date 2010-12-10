class Neighborhood < ActiveRecord::Base
  has_many :users
  belongs_to :community

  has_many :notifications, :as => :notified

  serialize :bounds, Array

  validates_presence_of :name, :bounds

  def posts
    users.map(&:posts).flatten
  end

end
