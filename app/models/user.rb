class User < ActiveRecord::Base

  before_save :update_lat_and_lng, :if => "address_changed?"
  before_create :place_in_community
  acts_as_authentic do |c|
    c.login_field :email
  end
  
  belongs_to :community
  
  has_many :links, :as => :linker

  has_many_polymorphs :linkables, :from => [:events], :through => :links, :as => :linker

  has_many :organizations
  has_many :attendances
  has_many :posts
  has_many :replies
  has_many :subscriptions
  has_many :organizations, :through => :subscriptions, :source => :organization

  has_many :roles
  has_many :managable_organizations, :through => :roles, :source => :organization

  has_many :referrals, :foreign_key => "referee_id"
  
  has_many :messages
  has_many :mets, :foreign_key => "requestee_id"
  
  has_many :notifications

  validates_presence_of :first_name, :last_name
  validates_acceptance_of :privacy_policy

  acts_as_taggable_on :skills
  acts_as_taggable_on :interests
  acts_as_taggable_on :stuffs
  
  has_attached_file(:avatar, 
                    :styles => { :thumb => "100x100" },
                    :default_url => "/avatars/missing.png")


  def search(term)
    User.all
  end

  def full_name
    first_name + " " + last_name
  end
  
  def name
    first_name + " " + last_name[/^./] + "."
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
  
  def wire
    (self.organizations.map(&:announcements).flatten + Event.all(:order => "created_at DESC") + Post.all(:order => "created_at DESC")).sort_by(&:created_at).reverse
  end

  def role_symbols
    if new_record?
      [:guest]
    else
      [:user]
    end
  end

  # TODO: find community based on address
  def place_in_community
    self.community = Community.first
  end


end
