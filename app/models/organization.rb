class Organization < ActiveRecord::Base
  CATEGORIES = %w{Municipal Business Civic}
  
  acts_as_taggable_on :tags

  validates_presence_of :name, :address
  validates_format_of :website, :with => /^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?$/ix, :allow_blank => true
  
  belongs_to :community
  
  has_many :events
  has_many :announcements

  has_many :profile_fields, :order => "position"

  has_many :subscriptions
  has_many :subscribers, :through => :subscriptions, :source => :user

  has_many :roles
  has_many :admins, :through => :roles, :source => :user

  has_many :invites, :as => :inviter

  before_save :update_lat_and_lng, :if => "address_changed?"

  before_create :set_default_avatar

  has_one :avatar, :as => :owner

  has_friendly_id :name, :use_slug => true, :scope => :community

  accepts_nested_attributes_for :profile_fields

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


  def avatar_url(style = :default)
    avatar.image.url(style)
  end

  def to_param
    self.id.to_s
  end
  
  protected


  def after_initialize
    if new_record? && profile_fields.empty?
      profile_fields.build([{:subject => "History", :body => ""},
                            {:subject => "About", :body => ""}])
    end
  end

  def set_default_avatar
    if self.avatar.nil?
      self.avatar = Avatar.new
    end
  end

end
