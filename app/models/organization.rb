class Organization < ActiveRecord::Base
  CATEGORIES = %w{Municipal Business Non-profit Club}
  acts_as_taggable_on :tags

  validates_presence_of :name, :message => "nice message"
  validates_format_of :website, :with => /^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?$/ix, :allow_blank => true
  
  belongs_to :community
  
  has_many :events
  has_many :announcements

  has_many :profile_fields, :order => "position"

  has_many :subscriptions
  has_many :subscribers, :through => :subscriptions, :source => :user

  has_many :roles
  has_many :admins, :through => :roles, :source => :user

  has_attached_file(:avatar, :styles => { :thumb => "100x100" })

  before_save :update_lat_and_lng, :if => "address_changed?"

  before_create :place_in_community

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


  protected

  # TODO: find community based on address
  def place_in_community
    self.community = Community.first
  end
  
end
