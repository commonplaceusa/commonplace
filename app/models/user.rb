class NamedPoint
  attr_accessor :lat, :lng, :name, :address
end

class User < ActiveRecord::Base

  before_save :ensure_authentication_token

  serialize :metadata, Hash
  serialize :private_metadata, Hash

  #track_on_creation
  include Geokit::Geocoders

  def self.post_receive_options
    ["Live", "Three", "Daily", "Never"]
  end


  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i

  devise :trackable, :database_authenticatable, :encryptable, :token_authenticatable, :recoverable, :omniauthable, :omniauth_providers => [:facebook]

  def self.find_for_facebook_oauth(access_token)
    User.find_by_facebook_uid(access_token["uid"])
  end

  def self.new_from_facebook(params, facebook_data)
    User.new(params).tap do |user|
      user.email = facebook_data["info"]["email"]
      user.full_name = facebook_data["info"]["name"]
      user.facebook_uid = facebook_data["uid"]
    end
  end


  geocoded_by :normalized_address

  belongs_to :community
  belongs_to :neighborhood  
  has_many :thanks
  
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
  validates_uniqueness_of :facebook_uid, :allow_blank => true

  scope :between, lambda { |start_date, end_date| 
    { :conditions => 
      ["? <= created_at AND created_at < ?", start_date.utc, end_date.utc] } 
  }

  scope :today, { :conditions => ["created_at between ? and ?", DateTime.now.utc.beginning_of_day, DateTime.now.utc.end_of_day] }

  scope :this_week, { :conditions => ["created_at between ? and ?", DateTime.now.utc.beginning_of_week, DateTime.now.utc.end_of_day] }

  scope :up_to, lambda { |end_date| { :conditions => ["created_at <= ?", end_date.utc] } }

  scope :logged_in_since, lambda { |date| { :conditions => ["last_login_at >= ?", date.utc] } }

  # HACK HACK HACK avatar_url should not be hardcoded like this
  scope :pretty, { :conditions => ["about != '' OR goods != '' OR interests != '' OR avatar_file_name IS NOT NULL"] }
  
  scope :have_sent_messages, lambda {|user| joins(:received_messages).where(messages: { user_id: user.id }) }

  def facebook_user?
    facebook_uid
  end
  
  def validate_password?
    if facebook_user?
      return false
    end
    return true
  end
  
  validates_presence_of :encrypted_password, :if => :validate_password?

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

  def self.find_by_full_name(full_name)
    name = full_name.split(" ")
    where("LOWER(users.last_name) = ? AND LOWER(users.first_name) = ?", name.last, name.first)
  end

  def reset_password(new_password = "cp123")
    self.password = new_password
    self.password_confirmation = new_password
    self.save
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

  has_many :feed_owners
  has_many :managable_feeds, :through => :feed_owners, :class_name => "Feed", :source => :feed
  has_many :direct_events, :class_name => "Event", :as => :owner, :include => :replies, :dependent => :destroy

  has_many :referrals, :foreign_key => "referee_id"
  has_many :sent_messages, :dependent => :destroy, :class_name => "Message"

  has_many :received_messages, :as => :messagable, :class_name => "Message", :dependent => :destroy

  has_many :messages

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
                      :default_url => "https://s3.amazonaws.com/commonplace-avatars-production/missing.png"
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
  
  acts_as_api

  api_accessible :default do |t|
    t.add :id
    t.add lambda {|u| "users"}, :as => :schema
    t.add lambda {|u| u.avatar_url(:normal)}, :as => :avatar_url
    t.add lambda {|u| "/users/#{u.id}"}, :as => :url
    t.add :name
    t.add :first_name
    t.add :last_name
    t.add :about
    t.add :interest_list, :as => :interests
    t.add :good_list, :as => :goods
    t.add :skill_list, :as => :skills
    t.add :links
    t.add lambda {|u| u.posts.count}, :as => :post_count
    t.add lambda {|u| u.replies.count}, :as => :reply_count
    t.add lambda {|u| u.profile_history }, :as => :history
    t.add lambda {|u| "true" }, :as => :success
  end

  def links
    { 
      "messages" => "/users/#{id}/messages",
      "self" => "/users/#{id}",
      "postlikes" => "/users/#{id}/postlikes"
    }
  end

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

  def messages
    self.sent_messages.select {|m| m.replies.count > 0 }
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

  def feed_messages
    Message.where("messagable_type = 'Feed' AND messagable_id IN (?)", self.managable_feed_ids)
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
    if is_facebook_user && !self.avatar.file?
      facebook_avatar_url
    else
      self.avatar.url(style_name || self.avatar.default_style)
    end
  end

  def value_adding?
    self.posts.count > 0 or self.announcements.count > 0 or self.direct_events.count > 0 or self.group_posts.count > 0
  end

  def normalized_address
    if address.match(/#{self.community.name}/i)
      address
    else
      address + ", #{self.community.name}"
    end
  end

  def generate_point
    if self.attempted_geolocating or (self.generated_lat.present? and self.generated_lng.present?)
      if self.attempted_geolocating and not self.generated_lat.present?
        return
      end
    else
      self.attempted_geolocating = true
      loc = MultiGeocoder.geocode("#{self.address}, #{self.community.zip_code}")
      self.generated_lat = loc.lat
      self.generated_lng = loc.lng
      self.save
    end
    point = NamedPoint.new
    point.lat = self.generated_lat
    point.lng = self.generated_lng
    point.name = self.full_name
    point.address = self.address
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

  def emails_are_limited?
    self.post_receive_method == "Three"
  end

  def meets_limitation_requirement?
    self.emails_sent <= 3
  end

  def inbox
    Message.where(<<WHERE, self.id, self.id)
    ("messages"."user_id" = ? AND
    (SELECT COUNT(*) FROM "replies" WHERE "replies"."repliable_type" = 'Message' AND
    "replies"."repliable_id" = "messages"."id") > 0) OR
    ("messages"."messagable_type" = 'User' AND
    "messages"."messagable_id" = ?)
WHERE
  end

  searchable do
    text :user_name do
      full_name
    end
    text :about
    text :skills
    text :goods
    text :interests
    integer :community_id
    time :created_at
  end

  def skill_list
    (self.skills || "").split(", ")
  end

  def interest_list
    (self.interests || "").split(", ")
  end

  def good_list
    (self.goods || "").split(", ")
  end

  def skill_list=(skill_list)
    case skill_list
    when Array
      self.skills = skill_list.join(", ")
    else
      self.skills = skill_list
    end
  end

  def good_list=(good_list)
    case good_list
    when Array
      self.goods = good_list.join(", ")
    else
      self.goods = good_list
    end
  end

  def interest_list=(interest_list)
    case interest_list
    when Array
      self.interests = interest_list.join(", ")
    else
      self.interests = interest_list
    end
  end

  def send_reset_password_instructions
    generate_reset_password_token! if should_generate_token?
    kickoff.deliver_password_reset(self)
  end

  def kickoff=(kickoff)
    @kickoff = kickoff
  end

  def kickoff
    @kickoff ||= KickOff.new
  end

  def last_checked_inbox
    read_attribute(:last_checked_inbox) || Time.at(0).to_datetime
  end

  def unread
    (self.inbox + self.feed_messages).select { |m|
      m.updated_at > self.last_checked_inbox
    }.length
  end

  def checked_inbox!
    self.last_checked_inbox = DateTime.now
    self.save :validate => false
  end

  def invitations_this_week
    Invite.this_week.select { |i| i.inviter_id == self.id }
  end

  def all_invitations
    Invite.find_all_by_inviter_id(self.id)
  end

  def replies_received
    (self.posts.map(&:replies) + self.events.map(&:replies) + self.announcements.map(&:replies) + self.group_posts.map(&:replies)).flatten
  end

  def replies_received_this_week
    (self.posts.this_week.map(&:replies) + self.events.this_week.map(&:replies) + self.announcements.this_week.map(&:replies) + self.group_posts.this_week.map(&:replies)).flatten
  end

  def posted_content
    self.posts + self.events + self.announcements + self.group_posts
  end

  def thanks_received
    self.posted_content.map(&:thanks).flatten
  end

  def thanks_received_this_week
    self.posted_content.map{ |content| content.thanks.this_week }.flatten
  end

  def weekly_cpcredits
    self.posts.this_week.count + self.replies.this_week.count + self.replies_received_this_week.count + self.events.this_week.count + self.invitations_this_week.count + self.thanks.this_week.count + self.thanks_received_this_week.count
  end

  def all_cpcredits
    self.posts.count + self.replies.count + self.replies_received.count + self.events.count + self.all_invitations.count + self.thanks.count + self.thanks_received.count
  end
  
  def featured # not user-relevant yet
    self.community.users.reorder("
      (Case When avatar_file_name IS NOT NULL Then 1 Else 0 End)
      + (Case When about != '' OR goods != '' OR interests != '' Then 1 Else 0 End) DESC")
    .order("calculated_cp_credits DESC")
  end

  def nag_banner_text
    if !self.community.has_launched?
      "Hey #{self.first_name}, welcome to #{self.community.name} CommonPlace! We're officially launching on #{self.community.launch_date.strftime("%B")} #{self.community.launch_date.day.ordinalize}. In the meantime, help us improve by <a href='/#{self.community.slug}/invite'>inviting some more neighbors</a>."
    elsif !self.avatar.file? and !self.metadata["closed_facebook_nag"] and !self.metadata["completed_facebook_nag"] and (self.value_adding? or self.replies.count > 0)
      javascript = <<js
facebook_connect_post_registration(function() {
  CommonPlace.account.set_metadata("completed_facebook_nag", true, function() {
    $(".important-notification").hide();
    CommonPlace.layout.reset();
    CommonPlace.infoBox.renderProfile(CommonPlace.account);
  });
}, function() { });
js
      cancel = <<js
$(".important-notification").hide();
CommonPlace.layout.reset();
js
      "<a href='javascript: #{cancel}' class='cancel'></a>Add a photo to your profile now! <a href='javascript: #{javascript}'>Connect with Facebook</a>."
    else
      nil
    end
  end

  def profile_history_elements
    self.posts + 
      self.direct_events + 
      self.announcements + 
      self.group_posts + 
      self.replies.where("repliable_type != 'Message'")
  end

  def profile_history
    self.profile_history_elements
      .sort_by(&:created_at)
      .reverse
      .map {|e| e.as_api_response(:history) }
  end

  searchable do
    text :name do
      self.name
    end
  end

  def validation_errors
    UserErrors.new(self)
  end

  private

  def is_transitional_user
    transitional_user
  end

end
