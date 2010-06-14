class Event < ActiveRecord::Base
  
  validates_presence_of :name

  has_many :attendances
  has_many :users, :through => :attendances
  
  has_many :sponsorships

  has_many :businesses, :through => :sponsorships, :source => :business,
                        :conditions => "sponsorships.sponsor_type = 'Business'"

  has_many :organization, :through => :sponsorships, :source => :organization,
                        :conditions => "sponsorships.sponsor_type = 'Organization'"


  def sponsors
    self.businesses + self.organizations
  end
end
