class User < ActiveRecord::Base

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

  has_one :location, :as => :locatable

  accepts_nested_attributes_for :location

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

  def address
    self.location.street_address
  end
  
  def set_default_avatar
    if self.avatar.nil?
      self.avatar = Avatar.new
    end
  end

  def after_initialize
    unless self.location
      self.location = Location.new
    end
  end
  
  alias_method :real_neighborhood, :neighborhood

  def neighborhood
    real_neighborhood || Neighborhood.new
  end
  
end
