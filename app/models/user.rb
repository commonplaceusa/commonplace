class User < ActiveRecord::Base

  before_save :update_lat_and_lng, :if => "address_changed?"
  before_create :set_default_avatar
  acts_as_authentic do |c|
    c.login_field :email
  end
  
  belongs_to :neighborhood  
  
  has_many :links, :as => :linker

  has_many :attendances
  has_many :events, :through => :attendances
  has_many :posts
  has_many :replies
  has_many :subscriptions
  has_many :organizations, :through => :subscriptions
  has_many :roles
  has_many :managable_organizations, :through => :roles, :source => :organization

  has_many :referrals, :foreign_key => "referee_id"
  
  has_many :messages
  has_many :mets, :foreign_key => "requester_id"
  
  has_many :people, :through => :mets, :source => "requestee"
  
  has_many :notifications

  validates_presence_of :first_name, :last_name
  validates_acceptance_of :privacy_policy

  acts_as_taggable_on :skills
  acts_as_taggable_on :interests
  acts_as_taggable_on :goods

  has_one :avatar, :as => :owner

  def subscribed_announcements
    organizations.map(&:announcements).flatten
  end

  def suggested_events
    []
  end

  def avatar_url(style = :default)
    avatar.image.url(style)
  end

  def search(term)
    User.all
  end

  def full_name
    first_name + " " + last_name
  end
  
  def name
    full_name
  end
  
  # TODO: pull this out into a module
  def update_lat_and_lng
    location = Geokit::Geocoders::GoogleGeocoder.geocode(address)
    if location.success?
      write_attribute(:lat,location.lat)
      write_attribute(:lng, location.lng)
      write_attribute(:address, location.full_address)
    end    
    true  
  end

  def community
    neighborhood.community
  end
  
  def wire
    (subscribed_announcements + organizations.map(&:events).flatten + neighborhood.posts).sort_by(&:created_at).reverse
  end

  def role_symbols
    if new_record?
      [:guest]
    else
      [:user]
    end
  end
  
  def set_default_avatar
    if self.avatar.nil?
      self.avatar = Avatar.new
    end
  end

end
