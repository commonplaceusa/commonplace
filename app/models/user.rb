class User < ActiveRecord::Base

  before_save :update_lat_and_lng, :if => "address_changed?"

  acts_as_authentic do |c|
    c.login_field :email
  end
  
  belongs_to :community
  
  has_many :links, :as => :linker

  has_many_polymorphs :linkables, :from => [:events], :through => :links, :as => :linker

  has_many :organizations
  has_many :attendances
  has_many :posts
  
  has_many :subscriptions
  has_many :organizations, :through => :subscriptions, :source => :organization

  has_many :roles
  has_many :managable_organizations, :through => :roles, :source => :organization

  has_many :referrals, :foreign_key => "referee_id"
  
  has_many :messages
  has_many :thread_memberships
  has_many :mets, :foreign_key => "requestee_id"
  

  validates_presence_of :first_name, :last_name
  validates_acceptance_of :privacy_policy, :on => :create

  acts_as_taggable_on :skills
  acts_as_taggable_on :interests
  acts_as_taggable_on :stuffs
  
  has_attached_file(:avatar, 
                    :styles => { :thumb => "100x100" },
                    :default_url => "/system/avatars/missing.png")


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

  def inbox
    self.referrals + 
      PlatformUpdate.all + 
      self.mets + 
      self.thread_memberships.unread +
      self.attendances.unread
  end
  
  def inbox_size
    "Inbox (1)" 
  end

  def role_symbols
    if new_record?
      [:guest]
    else
      [:user]
    end
  end

end
