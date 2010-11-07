class Feed < ActiveRecord::Base
  
  acts_as_taggable_on :tags

  validates_presence_of :name
  
  belongs_to :community
  belongs_to :user

  has_many :events, :dependent => :destroy, :as => :owner

  has_many :announcements, :dependent => :destroy
  
  has_many :profile_fields, :order => "position"

  has_many :subscriptions, :dependent => :destroy
  has_many :subscribers, :through => :subscriptions, :source => :user

  has_one :avatar, :as => :owner, :dependent => :destroy

  accepts_nested_attributes_for :profile_fields

  def avatar_url(style = :default)
    avatar.image.url(style)
  end

  def set_default_avatar
    if self.avatar.nil?
      self.avatar = Avatar.new
    end
  end

  def after_initialize
    set_default_avatar
  end
end
