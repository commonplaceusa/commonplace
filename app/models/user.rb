class User < ActiveRecord::Base

  before_save :update_lat_and_lng, :if => "address_changed?"

  acts_as_authentic do |c|
    c.login_field :email
  end

  has_many :attendances
  has_many :events, :through => :attendances

  has_many :posts

  has_many :messages
  has_many :conversation_memberships
  has_many :conversations, :through => :conversation_memberships

  validates_presence_of :first_name, :last_name

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


end
