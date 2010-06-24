class Group < ActiveRecord::Base
  acts_as_taggable_on :interests

  validates_presence_of :name, :message => "nice message"

  has_many :sponsorships, :as => :sponsor
  has_many :events, :through => :sponsorships, :as => :sponsor
  
  has_many :group_memberships
  has_many :members, :through => :group_memberships, :class_name => "User"

  has_many :text_modules, :order => "position"

  has_attached_file(:avatar, :styles => { :thumb => "100x100" })

  
  before_save :update_lat_and_lng, :if => "address_changed?"

  # TODO: pull this out into a module
  def update_lat_and_lng
    if address.blank?
      true
    else
      location = Geokit::Geocoders::GoogleGeocoder.geocode(address)
      if location && location.success?
        write_attribute(:lat,location.lat)
        write_attribute(:lng, location.lng)
        write_attribute(:address, location.full_address)
      else
        false
      end    
    end
  end



end
