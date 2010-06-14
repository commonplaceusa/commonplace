class Business < ActiveRecord::Base

  has_many :sponsorships
  has_many :events, :through => :sponsorships

  validates_presence_of :name

  has_attached_file(:avatar, :styles => { :thumb => "100x100" })

end
