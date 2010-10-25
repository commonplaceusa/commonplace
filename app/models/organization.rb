class Organization < ActiveRecord::Base
  CATEGORIES = %w{Business Organization}
  
  acts_as_taggable_on :tags

  validates_presence_of :name, :address
  validates_format_of :website, :with => /^(http|https)?:\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?$/ix, :allow_blank => true  

  named_scope :business, :conditions => ["category = ?", "Business"]
  named_scope :organization, :conditions => ["category = ?", "Organization"]

  belongs_to :community
  
  has_many :events
  has_many :announcements

  has_many :profile_fields, :order => "position"

  has_many :subscriptions
  has_many :subscribers, :through => :subscriptions, :source => :user

  has_many :roles
  has_many :admins, :through => :roles, :source => :user

  has_many :invites, :as => :inviter

  has_many :notifications, :as => :notified

  before_create :set_default_avatar

  has_one :avatar, :as => :owner

  has_one :location, :as => :locatable

  has_friendly_id :name, :use_slug => true, :scope => :community

  accepts_nested_attributes_for :profile_fields
  
  accepts_nested_attributes_for :location

  def avatar_url(style = :default)
    avatar.image.url(style)
  end

  def to_param
    self.id.to_s
  end

  def address
    self.location.street_address
  end
  
  protected

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
end
