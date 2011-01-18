class Neighborhood < ActiveRecord::Base
  has_many :users
  has_many :posts, :order => "created_at DESC", :include => {:replies => :user}
  belongs_to :community

  has_many :notifications, :as => :notified

  serialize :bounds, Array

  validates_presence_of :name, :bounds

end
