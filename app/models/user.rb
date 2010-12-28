class User < ActiveRecord::Base
  
  # State machine
  # This is messy, but it's the way I was able to get the system working.
  
  # A cleaner implementation would have a single function that checks and returns the status
  
  def check_state
    if self.first_name && self.last_name && self.email
      if self.crypted_password
        if self.about || self.cached_skill_list
          if (self.state != :oneA)
            update_state_to_oneA
          end
        else
          if (self.state != :oneB)
            update_state_to_oneB
          end
        end
      else
        if (self.state != :twoA)
          update_state_to_twoA
        end
      end
    else
      if user.email
        if (self.state != :three)
          update_state_to_three
        end
      else
        if (self.state != :four)
          update_state_to_four
        end
      end
    end
  end
  
  include AASM
  
  aasm_column :state
  
  aasm_state :nullstate
  
  aasm_initial_state Proc.new { |user|
    if user.first_name && user.last_name && user.email
      if user.crypted_password
        if user.about || user.cached_skill_list
          :oneA
        else
          :oneB
        end
      else
        :twoA
      end
    else
      if user.email
        :three
      else
        :four
      end
    end
  }
  aasm_state :oneA
  aasm_state :oneB
  aasm_state :twoA
  aasm_state :three
  aasm_state :four
  
  
  
  aasm_event :update_state_to_oneA do
    transitions :to => :oneA, :from => [:oneA, :oneB, :twoA, :three, :four]
  end
  
  aasm_event :update_state_to_oneB do
    transitions :to => :oneB, :from => [:oneA, :oneB, :twoA, :three, :four]
  end
  
  aasm_event :update_state_to_twoA do
    transitions :to => :twoA, :from => [:oneA, :oneB, :twoA, :three, :four]
  end
  
  aasm_event :update_state_to_three do
    transitions :to => :three, :from => [:oneA, :oneB, :twoA, :three, :four]
  end
  
  aasm_event :update_state_to_four do
    transitions :to => :four, :from => [:oneA, :oneB, :twoA, :three, :four]
  end

  # after_save :check_state
  

  acts_as_authentic do |c|
    c.login_field :email
    c.require_password_confirmation = false
    c.validate_email_field=false
    c.validate_password_field=false
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

  validates_uniqueness_of :email
  validates_presence_of :first_name, :last_name
  validates_presence_of :location
  acts_as_taggable_on :skills
  acts_as_taggable_on :interests
  acts_as_taggable_on :goods

  def validate 
    errors.add(:full_name, "can't be blank") if first_name.blank? || last_name.blank?
  end 
  
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
    @full_name = string
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
