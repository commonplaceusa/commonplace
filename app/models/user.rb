class User < ActiveRecord::Base

  before_create :set_default_avatar
  acts_as_authentic do |c|
    c.login_field :email
    c.require_password_confirmation = false
  end
  
  belongs_to :neighborhood  
  
  has_many :attendances, :dependent => :destroy
  has_many :events, :through => :attendances
  has_many :posts, :dependent => :destroy
  has_many :replies, :dependent => :destroy
  has_many :subscriptions, :dependent => :destroy
  has_many :feeds, :through => :subscriptions
  has_many :managable_feeds, :class_name => "Feed"
  has_many :direct_events, :class_name => "Event", :as => :owner

  has_many :referrals, :foreign_key => "referee_id"
  
  has_many :messages
  has_many :mets, :foreign_key => "requester_id"
  
  has_many :people, :through => :mets, :source => "requestee"
  
  has_many :notifications

  has_one :location, :as => :locatable

  accepts_nested_attributes_for :location, :update_only => true

  validates_presence_of :first_name, :last_name
  validates_acceptance_of :privacy_policy
  validates_confirmation_of :email
  validates_presence_of :location
  acts_as_taggable_on :skills
  acts_as_taggable_on :interests
  acts_as_taggable_on :goods

  has_one :avatar, :as => :owner

  def subscribed_announcements
    feeds.map(&:announcements).flatten
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
    new_record? ?
    (community.announcements + community.events).sort_by(&:created_at).reverse :
    (subscribed_announcements + feeds.map(&:events).flatten + neighborhood.posts).sort_by(&:created_at).reverse
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
