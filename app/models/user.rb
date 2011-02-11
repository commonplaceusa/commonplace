class User < ActiveRecord::Base

  acts_as_authentic do |c|
    c.login_field :email
    c.require_password_confirmation = false
    c.validate_email_field=false
    c.validate_password_field=false
  end
  
  belongs_to :community
  belongs_to :neighborhood  
  
  before_validation :place_in_neighborhood
  validates_presence_of :community
  validates_presence_of :address, :on => :create, :unless => :authenticating_with_oauth2?
  validates_presence_of :address, :on => :update

  validates_presence_of :password, :on => :update, :unless => :facebook_user?

  def facebook_user?
    authenticating_with_oauth2? || facebook_uid
  end
  
  validates_uniqueness_of :email
  validates_presence_of :first_name, :last_name, :neighborhood
  
  def after_oauth2_authentication
    json = oauth2_access.get('/me')
    
    if user_data = JSON.parse(json)
      self.full_name = user_data['name']
      self.facebook_uid = user_data['id']
      self.email = user_data['email']
    end
  end
  
  def send_to_facebook
    redirect_to_oauth2
  end


  
  has_many :attendances, :dependent => :destroy
  has_many :events, :through => :attendances
  has_many :posts, :dependent => :destroy
  has_many :replies, :dependent => :destroy
  has_many :subscriptions, :dependent => :destroy
  has_many :feeds, :through => :subscriptions
  has_many :managable_feeds, :class_name => "Feed"
  has_many :direct_events, :class_name => "Event", :as => :owner, :include => :replies, :dependent => :destroy

  has_many :referrals, :foreign_key => "referee_id"
  has_many :messages

  has_many :received_messages, :as => :messagable, :class_name => "Message"

  has_many :mets, :foreign_key => "requester_id"
  
  has_many :people, :through => :mets, :source => "requestee"

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

  def inbox
    (self.received_messages + self.messages).sort {|m,n| n.updated_at <=> m.updated_at }
  end


  def client
    OAuth2::Client.new(CONFIG['facebook_api_key'], CONFIG['facebook_secret_key'], :site => 'https://graph.facebook.com')
  end
  
  def access_token
    OAuth2::AccessToken.new(client,self.oauth2_token)
  end
  
  def facebook_profile_data
    JSON.parse(access_token.get("/me"))
  end

  def validate 
    errors.add(:full_name, "We need your first and last names.") if first_name.blank? || last_name.blank?
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
    self.first_name, self.last_name = (string.present? ? string.split(" ", 2) : ["",""])
    self.first_name.try(:capitalize!)
    self.last_name.try(:capitalize!)
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

  def place_in_neighborhood
    if self.community.present? && self.neighborhood.blank? || self.address_changed?
      self.neighborhood = self.community.neighborhood_for(self.address)
    end
  end
  
end
