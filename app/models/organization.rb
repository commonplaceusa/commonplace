class Organization < ActiveRecord::Base
  acts_as_taggable_on :interests

  validates_presence_of :name, :message => "nice message"
  validates_format_of :website, :with => /^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?$/ix, :allow_blank => true
  
  has_many :events
  has_many :announcements

  has_many :text_modules, :order => "position"

  has_many :roles
  has_many :admins, :through => :roles, :class_name => "User"

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
