class Feed < ActiveRecord::Base
  #track_on_creation

  validates_presence_of :name, :community

  # validates_attachment_presence :avatar

  validates_uniqueness_of :slug, :scope => :community_id, :allow_nil => true

  scope :featured, reorder("
    (Case When about != '' OR address != '' Then 1 Else 0 End)
    + Case When avatar_file_name IS NOT NULL Then 1 Else 0 End DESC")

  before_validation(:on => :create) do
    if self.slug?
      sanitize_slug
    else
      generate_slug
    end
    true
  end

  def posted_between?(start_date, end_date)
    (self.events.present? and self.events.last.created_at >= start_date and self.events.last.created_at <= end_date) or
      (self.announcements.present? and self.announcements.last.created_at >= start_date and self.announcements.last.created_at <= end_date)
  end

  scope :updated_between, lambda { |start_date, end_date|
    { :conditions =>
      ["? <= updated_at AND updated_at < ?", start_date.utc, end_date.utc] }
  }

  belongs_to :community
  has_many :feed_owners
  has_many :owners, :through => :feed_owners, :class_name => "User", :source => :user
  belongs_to :user,:counter_cache => true

  has_many :events, :dependent => :destroy, :as => :owner, :include => :replies
  has_many :transactions, :as => :owner

  has_many :announcements, :dependent => :destroy, :as => :owner, :include => :replies

  has_many :subscriptions, :dependent => :destroy
  has_many :subscribers, :through => :subscriptions, :source => :user, :uniq => true

  has_many :swipes
  has_many :swiped_visitors, :through => :swipes, :class_name => "User", :source => :user

  acts_as_api

  api_accessible :default do |t|
    t.add :id
    t.add lambda {|f| "feeds"}, :as => :schema
    t.add :slug
    t.add :user_id
    t.add lambda {|f| "/pages/#{f.slug}"}, :as => :url
    t.add :name
    t.add :about
    t.add lambda {|f| f.avatar_url(:normal)}, :as => :avatar_url
    t.add lambda {|f| f.avatar_url(:original)}, :as => :avatar_original
    t.add lambda {|f| "/feeds/#{f.id}/profile"}, :as => :profile_url
    t.add :feed_url, :as => :rss
    t.add lambda {|f| "/feeds/#{f.id}/delete"}, :as => :delete_url
    t.add :tag_list, :as => :tags
    t.add :website
    t.add :phone
    t.add :address
    t.add :kind
    t.add lambda {|f| "/feeds/#{f.id}/#{f.user_id}"}, :as => :messagable_author_url
    t.add lambda {|f| f.name}, :as => :messagable_author_name
    t.add :links
    t.add lambda {|f| f.announcements.count}, :as => :announcement_count
    t.add lambda {|f| f.events.count}, :as => :event_count
    t.add lambda {|f| f.subscribers.count}, :as => :subscriber_count
    t.add lambda {|f| f.owner}, :as => :owner
  end

  def owner
    if self.user.present?
      self.user.name
    else
      "No Owner?"
    end
  end

  def links
    {
      "avatar" => {
        "large" => self.avatar_url(:large),
        "normal" => self.avatar_url(:normal),
        "thumb" => self.avatar_url(:thumb)
      },
      "avatar_edit" => "/feeds/#{id}/avatar",
      "crop" => "/feeds/#{id}/crop",
      "announcements" => "/feeds/#{id}/announcements",
      "events" => "/feeds/#{id}/events",
      "invites" => "/feeds/#{id}/invites",
      "messages" => "/feeds/#{id}/messages",
      "edit" => "/feeds/#{id}/edit",
      "subscribers" => "/feeds/#{id}/subscribers",
      "transactions" => "/feeds/#{id}/transactions",
      "self" => "/feeds/#{id}",
      "owners" => "/feeds/#{id}/owners",
      "swipes" => "/feeds/#{id}/swipes"
    }
  end

  def live_subscribers
    self.subscriptions.all(:conditions => "receive_method = 'Live'").map &:user
  end

  include CroppableAvatar
  has_attached_file(:avatar,
                    { :styles => {
                        :thumb => {:geometry => "100x100", :processors => [:cropper]},
                        :normal => {:geometry => "120x120", :processors => [:cropper]},
                        :large => {:geometry => "200x200", :processors => [:cropper]},
                        :original => "1000x1000>"
                      },
                      :default_url => "https://s3.amazonaws.com/commonplace-avatars-production/missing.png"
                    }.merge(Rails.env.development? || Rails.env.test? ?
                            { :path => ":rails_root/public/system/feeds/:id/avatar/:style.:extension",
                              :storage => :filesystem,
                              :url => "/system/feeds/:id/avatar/:style.:extension"
                            } : {
                              :storage => Rails.env.development? ? :filesystem : :s3,
                              :s3_protocol => "https",
                              :bucket => "commonplace-avatars-#{Rails.env}",
                              :path => "/feeds/:id/avatar/:style.:extension",
                              :s3_credentials => {
                                :access_key_id => ENV['S3_KEY_ID'],
                                :secret_access_key => ENV['S3_KEY_SECRET']
                              }
                            }))


  def tag_list
    self.cached_tag_list
  end

  def tag_list=(string)
    self.cached_tag_list = string
  end

  def website=(string)
    if string.present? && !(string =~ /^https?:\/\//)
      super("http://" + string)
    else
      super(string)
    end
  end

  def avatar_url(style_name = nil)
    self.avatar.url(style_name || self.avatar.default_style)
  end


  def wire
    (self.announcements + self.events).sort_by do |item|
      time = case item
             when Event then item.created_at
             when Announcement then item.created_at
             end
      (time - Time.now).abs
    end
  end

  def is_news
    self.kind == 4
  end

  def self.kinds
    feed_kinds = ActiveSupport::OrderedHash.new
    feed_kinds["A non-profit"] = 0
    feed_kinds["A community group"] = 1
    feed_kinds["A business"] = 2
    feed_kinds["A municipal entity"] = 3
    feed_kinds["A newspaper, news service, or news blog"] = 4
    feed_kinds["Other"] = 5
    feed_kinds
  end

  def self.subscriber_count_email_trigger
    10
  end

  def slug
    read_attribute(:slug).blank? ? id : read_attribute(:slug)
  end

  def messages
    Message.where("messagable_type = 'Feed' AND messagable_id = ?", self.id)
  end

  searchable do
    text :name
    text :about
    integer :community_id
  end

  def get_feed_owner(user)
    owner = self.feed_owners.select { |o| o.user == user }
    if (owner.empty?)
      false
    else
      owner
    end
  end

  def rss_feed
    RSSFeed.new(self)
  end


  private

  def sanitize_slug
    string = self.slug.split("@").first
    string.gsub!(/[']+/, '')
    string.gsub!(/\W+/, ' ')
    string.gsub!(/\W+/, ' ')
    string.strip!
    string.downcase!
    string.gsub!(' ', '-')
    self.slug = string
  end

  def generate_slug
    string = self.name.mb_chars.normalize(:kd).gsub(/[^\x00-\x7F]/n, '').to_s
    string.gsub!(/[']+/, '')
    string.gsub!(/\W+/, ' ')
    string.gsub!(/\W+/, ' ')
    string.strip!
    string.downcase!
    string.gsub!(' ', '-')
    if Feed.exists?(:slug => string, :community_id => self.community_id)
      self.slug = nil
    else
      self.slug = string
    end
  end
end
