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
  
  belongs_to :community
  belongs_to :neighborhood  
  
  before_validation :place_in_neighborhood
  
  validates_presence_of :address, :on => :create, :unless => :authenticating_with_oauth2?
  validates_presence_of :address, :on => :update
  
  def after_oauth2_authentication
    json = oauth2_access.get('/me')
    
    if user_data = JSON.parse(json)
      self.full_name = user_data['name']
      self.facebook_uid = user_data['id']
      self.email = user_data['email']
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

  validates_uniqueness_of :email
  validates_presence_of :first_name, :last_name, :neighborhood
  acts_as_taggable_on :skills
  acts_as_taggable_on :interests
  acts_as_taggable_on :goods


  has_attached_file(:avatar,                    
                    :styles => { 
                      :thumb => "100x100^", 
                      :normal => "120x120^",
                      :large => "200x200^"
                    },
                    :default_url => "/avatars/missing.png", 
                    :url => "/system/users/:id/avatar/:style.:extension",
                    :path => ":rails_root/public/system/users/:id/avatar/:style.:extension")


  def validate 
    errors.add(:full_name, "can't be blank") if first_name.blank? || last_name.blank?
  end 
  
  
  def subscribed_announcements
    feeds.map(&:announcements).flatten
  end

  def suggested_events
    []
  end

  def search(term)
    User.all
  end

  def full_name
    first_name && last_name ? first_name.to_s + " " + last_name.to_s : nil
  end

  def full_name=(string)
    @full_name = string
    first, last = string.split(" ", 2)
    self.first_name = first.capitalize if first
    self.last_name = last.capitalize if last
    self.full_name
  end

  def name
    full_name
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

  def feed_list
    feeds.map(&:name).join(", ")
  end


  def is_same_as(other_user)
    puts (other_user.email == self.email && other_user.crypted_password == self.crypted_password)
    (other_user.email == self.email && other_user.crypted_password == self.crypted_password)
  end
    
  def place_in_neighborhood
    if self.neighborhood.blank? || self.address_changed?
      position = LatLng.from_address(address, community.zip_code)
      if position
        self.neighborhood = community.neighborhoods.to_a.
          find(lambda{community.neighborhoods.first}) do |n|
          position.within?(n.bounds) if n.bounds
        end
      else
        self.neighborhood = community.neighborhoods.first
      end
    end
  end 
  
end
