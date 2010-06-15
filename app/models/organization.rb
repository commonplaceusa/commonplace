class Organization < ActiveRecord::Base

  acts_as_taggable_on :interests

  validates_presence_of :name

  has_many :sponsorships
  has_many :events, :through => :sponsorships

  has_many :text_modules, :order => "position"

  has_attached_file(:avatar, :styles => { :thumb => "100x100" })


end
