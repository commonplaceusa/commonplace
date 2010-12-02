class User < ActiveRecord::Base

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
  
  has_many :messages, :foreign_key => "recipient_id"
  has_many :mets, :foreign_key => "requester_id"
  
  has_many :people, :through => :mets, :source => "requestee"
  
  has_many :notifications, :as => :notified

  has_one :location, :as => :locatable

  accepts_nested_attributes_for :location, :update_only => true

  validates_presence_of :first_name, :last_name
  validates_acceptance_of :terms
  validates_confirmation_of :email, :on => :create
  validates_confirmation_of :password, :on => :update
  validates_presence_of :location
  acts_as_taggable_on :skills
  acts_as_taggable_on :interests
  acts_as_taggable_on :goods

  # def validate 
  #   errors.add(:full_name, "can't be blank") if first_name.blank? || last_name.blank?
  # end 

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
    first_name && last_name ? first_name.to_s + " " + last_name.to_s : nil
  end

  def full_name=(string)
    self.first_name, self.last_name = string.split(" ", 2)
  end

  def name
    full_name
  end
  
  def community
    neighborhood.community
  end
  
  def wire
    if new_record?
      community.announcements + community.events
    else
      subscribed_announcements + community.events + neighborhood.posts
    end.sort_by do |item|
      ((item.is_a?(Event) ? item.start_datetime : item.created_at) - Time.now).abs
    end
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
  
  def after_initialize
    unless self.location
      self.location = Location.new
    end
  end
  
  alias_method :real_neighborhood, :neighborhood

  def neighborhood
    real_neighborhood || Neighborhood.new
  end
  
  def is_same_as(other_user)
    puts (other_user.email == self.email && other_user.crypted_password == self.crypted_password)
    (other_user.email == self.email && other_user.crypted_password == self.crypted_password)
  end
  
end
