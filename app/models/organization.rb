class Organization < ActiveRecord::Base

  acts_as_taggable_on :interests

  validates_presence_of :name

  has_many :sponsorships
  has_many :events, :through => :sponsorships

end
