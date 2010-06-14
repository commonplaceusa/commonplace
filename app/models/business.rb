class Business < ActiveRecord::Base

  has_many :sponsorships
  has_many :events, :through => :sponsorships

  validates_presence_of :name

end
