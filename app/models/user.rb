class User < ActiveRecord::Base
  #track_on_creation

  def self.post_receive_options
    ["Live", "Daily", "Never"]
  end

  attr_accessor :crop_x, :crop_y, :crop_w, :crop_h
  after_update :reprocess_avatar, :if => :cropping?

  acts_as_authentic do |c|
    c.login_field :email
    c.require_password_confirmation = false
    c.validate_email_field=false
    c.validate_password_field=false
    c.ignore_blank_passwords = true
    c.merge_validates_length_of_email_field_options({:allow_nil => true})
    c.merge_validates_format_of_email_field_options({:allow_nil => true})
    c.perishable_token_valid_for 1.hour
  end

  geocoded_by :normalized_address

  belongs_to :community
  belongs_to :neighborhood  
  
  before_validation :geocode, :if => :address_changed?
  before_validation :place_in_neighborhood, :if => :address_changed?

  validates_presence_of :community
  validates_presence_of :address, :on => :create, :unless => :is_transitional_user
  validates_presence_of :address, :on => :update

  validates_presence_of :first_name, :unless => :is_transitional_user

    
  validate :validate_first_and_last_names, :unless => :is_transitional_user

  validates_presence_of :neighborhood, :unless => :is_transitional_user
  validates_uniqueness_of :facebook_uid, :allow_nil => true 

  validates_presence_of :password, :on => :update

  validates_presence_of  :referral_source, :on => :update, :if => :requires_referral_source

  def requires_referral_source
    self.community.slug == "Vienna"
  end

  scope :between, lambda { |start_date, end_date| 
    { :conditions => 
      ["? <= created_at AND created_at < ?", start_date.utc, end_date.utc] } 
  }

  scope :today, { :conditions => ["created_at between ? and ?", DateTime.now.utc.beginning_of_day, DateTime.now.utc.end_of_day] }

  scope :up_to, lambda { |end_date| { :conditions => ["created_at <= ?", end_date.utc] } }

  scope :logged_in_since, lambda { |date| { :conditions => ["last_login_at >= ?", date.utc] } }
  def facebook_user?
    authenticating_with_oauth2? || facebook_uid
  end
  
  def validate_password?
    if facebook_user?
      return false
    end
    return true
  end

  validates_presence_of :email
  validates_uniqueness_of :email
  validates_presence_of :first_name, :last_name

  def cropping?
    !crop_x.blank? && !crop_y.blank? && !crop_w.blank? && !crop_h.blank?
  end
  
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

  def self.find_by_email(email)
    where("LOWER(users.email) = ?", email.downcase).first
  end

  has_many :attendances, :dependent => :destroy

  has_many :events, :through => :attendances
  has_many :posts, :dependent => :destroy
  has_many :group_posts, :dependent => :destroy
  has_many :announcements, :dependent => :destroy, :as => :owner, :include => :replies

  has_many :replies, :dependent => :destroy


  has_many :subscriptions, :dependent => :destroy
  accepts_nested_attributes_for :subscriptions
  has_many :feeds, :through => :subscriptions, :uniq => true

  has_many :memberships, :dependent => :destroy
  accepts_nested_attributes_for :memberships
  has_many :groups, :through => :memberships, :uniq => true

  has_many :managable_feeds, :class_name => "Feed"
  has_many :direct_events, :class_name => "Event", :as => :owner, :include => :replies, :dependent => :destroy

  has_many :referrals, :foreign_key => "referee_id"
  has_many :messages, :dependent => :destroy

  has_many :received_messages, :as => :messagable, :class_name => "Message", :dependent => :destroy

  has_many :mets, :foreign_key => "requester_id"
  
  has_many :people, :through => :mets, :source => "requestee"

  has_attached_file(:avatar,                    
                    {:styles => { 
                        :thumb => {:geometry => "100x100", :processors => [:cropper]},
                        :normal => {:geometry => "120x120", :processors => [:cropper]},
                        :large => {:geometry => "200x200", :processors => [:cropper]},
                        :croppable => "400x400>"
                      },
                      :default_url => "/avatars/missing.png"
                    }.merge(Rails.env.development? || Rails.env.test? ? 
                            { :path => ":rails_root/public/system/users/:id/avatar/:style.:extension", 
                              :storage => :filesystem,
                              :url => "/system/users/:id/avatar/:style.:extension"
                            } : { 
                              :storage => :s3,
                              :s3_protocol => "https",
                              :bucket => "commonplace-avatars-#{Rails.env}",
                              :path => "/users/:id/avatar/:style.:extension",
                              :s3_credentials => {
                                :access_key_id => ENV['S3_KEY_ID'],
                                :secret_access_key => ENV['S3_KEY_SECRET']
                              }
                            }))
  


  def avatar_geometry(style = :original)
    @geometry ||= {}
    path = (avatar.options[:storage]==:s3) ? avatar.url(style) : avatar.path(style)
    @geometry[style] ||= Paperclip::Geometry.from_file(path)
  end

  scope :receives_weekly_bulletin, :conditions => {:receive_weekly_digest => true}

  scope :receives_daily_digest, :conditions => {:post_receive_method => "Daily"}

  scope :receives_posts_live, :conditions => {:post_receive_method => "Live"}


  def inbox
    (self.received_messages + self.messages).sort {|m,n| n.updated_at <=> m.updated_at }.select {|m| !m.archived }
  end


  def validate_first_and_last_names
    errors.add(:full_name, "We need your first and last names.") if first_name.blank? || last_name.blank?
  end 
  
  def daily_subscribed_announcements
    self.subscriptions.all(:conditions => "receive_method = 'Daily'").
      map(&:feed).map(&:announcements).flatten
  end

  def suggested_events
    []
  end

  def search(term)
    User.all
  end

  def full_name
    [first_name,middle_name,last_name].select(&:present?).join(" ")
  end

  def full_name=(string)
    split_name = string.to_s.split(" ")
    self.first_name = split_name.shift.to_s.capitalize
    self.last_name = split_name.pop.to_s.capitalize
    self.middle_name = split_name.map(&:capitalize).join(" ")
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

  def group_list
    groups.map(&:name).join(", ")
  end

  def place_in_neighborhood
    self.neighborhood = self.community.neighborhoods.near(self.to_coordinates, 15).first || self.community.neighborhoods.first
    unless self.neighborhood
      errors.add :address, I18n.t('activerecord.errors.models.user.address',
                                  :community => self.community.name)
    end
  end
  
  def is_facebook_user
    facebook_uid.present?
  end
  
  def facebook_avatar_url
    "https://graph.facebook.com/" + self.facebook_uid.to_s + "/picture/?type=large"
  end
  
  def avatar_url(style_name = nil)
    if Rails.env.development?
      return "/avatars/missing.png"
    else
      if is_facebook_user && !self.avatar.file?
        facebook_avatar_url
      else
        self.avatar.url(style_name || self.avatar.default_style)
      end
    end
  end

  def value_adding?
    (self.posts.size >= 1 || self.announcements.size >= 1 || self.events.size >= 1)
  end

  def normalized_address
    if address.match(/#{self.community.name}/i)
      address
    else
      address + ", #{self.community.name}"
    end
  end

  private
  def reprocess_avatar
    avatar.reprocess!
  end

  def is_transitional_user
    transitional_user
  end

end
