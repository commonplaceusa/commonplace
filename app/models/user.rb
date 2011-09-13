class User < ActiveRecord::Base
  acts_as_taggable_on :offers, :interests, :skills

  before_save :ensure_authentication_token

  #track_on_creation
  include Geokit::Geocoders

  def self.post_receive_options
    ["Live", "Three", "Daily", "Never"]
  end

  devise :database_authenticatable, :encryptable, :token_authenticatable, :recoverable
  
  geocoded_by :normalized_address

  belongs_to :community
  belongs_to :neighborhood  

  def organizer_data_points
    OrganizerDataPoint.find_all_by_organizer_id(self.id)
  end

  before_validation :geocode, :if => :address_changed?
  before_validation :place_in_neighborhood, :if => :address_changed?

  validates_presence_of :community
  validates_presence_of :address, :on => :create, :unless => :is_transitional_user, :message => "Please provide a street address so CommonPlace can verify that you live in our community."
  validates_presence_of :address, :on => :update
  

  validates_presence_of :first_name, :unless => :is_transitional_user 
  validate :validate_first_and_last_names, :unless => :is_transitional_user

  validates_presence_of :neighborhood, :unless => :is_transitional_user
  validates_uniqueness_of :facebook_uid, :allow_nil => true 

  scope :between, lambda { |start_date, end_date| 
    { :conditions => 
      ["? <= created_at AND created_at < ?", start_date.utc, end_date.utc] } 
  }

  scope :today, { :conditions => ["created_at between ? and ?", DateTime.now.utc.beginning_of_day, DateTime.now.utc.end_of_day] }

  scope :up_to, lambda { |end_date| { :conditions => ["created_at <= ?", end_date.utc] } }

  scope :logged_in_since, lambda { |date| { :conditions => ["last_login_at >= ?", date.utc] } }

  def facebook_user?
    facebook_uid
  end
  
  def validate_password?
    if facebook_user?
      return false
    end
    return true
  end

  validates_presence_of :email
  validates_uniqueness_of :email

  # HACK HACK HACK TODO: This should be in the database schema, or slugs for college towns should ALWAYS be the domain suffix
  validates_format_of :email, :with => /^([^\s]+)umw\.edu/, :if => :college?

  def college?
    self.community and self.community.is_college
  end

  validates_presence_of :first_name, :last_name

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

  include CroppableAvatar
  has_attached_file(:avatar,                    
                    {:styles => { 
                        :thumb => {:geometry => "100x100", :processors => [:cropper]},
                        :normal => {:geometry => "120x120", :processors => [:cropper]},
                        :large => {:geometry => "200x200", :processors => [:cropper]},
                        :original => "1000x1000>"
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

  scope :receives_posts_live, :conditions => {:post_receive_method => ["Live", "Three"]}

  scope :receives_posts_live_unlimited, :conditions => {:post_receive_method => "Live"}

  scope :receives_posts_live_limited, :conditions => {:post_receive_method => "Three"}


  def inbox
    (self.received_messages + self.messages).sort {|m,n| n.updated_at <=> m.updated_at }.select {|m| !m.archived }
  end


  def validate_first_and_last_names
    errors.add(:full_name, "CommonPlace requires people to register with their first \& last names.") if first_name.blank? || last_name.blank?
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
    if self.community.is_college
      self.neighborhood = self.community.neighborhoods.select { |n| n.name == self.address }.first
    else
      self.neighborhood = self.community.neighborhoods.near(self.to_coordinates, 15).first || self.community.neighborhoods.first
    end
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

  def generate_point
    if self.generated_lat.present? and self.generated_lng.present?
    else
      loc = MultiGeocoder.geocode("#{self.address}, #{self.community.zip_code}")
      self.generated_lat = loc.lat
      self.generated_lng = loc.lng
      self.save
    end
    point = Hash.new
    point['lat'] = self.generated_lat
    point['lng'] = self.generated_lng
    point
  end

  def self.received_reply_to_object_in_last(repliable_type, days_ago)
    # We expect repliable_type to be Post
    if repliable_type == 'Post'
      item = Post
    elsif repliable_type == 'Event'
      item = Event
    elsif repliable_type == 'Announcement'
      item = Announcement
    end
    user_ids = []
    Reply.between(days_ago.days.ago, Time.now).select {|r| r.repliable_type == repliable_type}.map(&:repliable_id).uniq.each do |i| user_ids << item.find(i).owner end
    user_ids
  end

  def has_received_message_within(time_ago)
    messages.between(time_ago, Time.now).select { |m| m.messagable_id == self.id and m.messagable_type == "User" }.present?
  end

  def self.received_no_reply_in_last(start_time)
    user_ids = []
    post_ids = []
    User.all.each do |u|
      unless u.has_received_message_within(start_time)
        u.posts.between(start_time, Time.now).each do |p|
          unless p.replies.present?
            post_ids << p.id
          end
        end
      end
    end
    post_ids.uniq
  end

  def emails_are_limited?
    self.post_receive_method == "Three"
  end

  unless Rails.env.test?
    searchable do
      string :first_name
      string :last_name
      string :about
      string :interest_list
      string :offer_list
      string :address
    end
    #handle_asynchronously :solr_index
  end

  # Devise calls this on POST /users/password
  def send_reset_password_instructions
    generate_reset_password_token! if should_generate_token?
    Kickoff.new.deliver_password_reset(self)
  end

  private

  def is_transitional_user
    transitional_user
  end

end
