class Post < ActiveRecord::Base
  include Trackable
  after_create :track_posted_content

  CATEGORIES = %w{Request Offer Invitation Announcement Question}

  delegate :neighborhood, :to => :user

  belongs_to :user, :counter_cache => true
  belongs_to :community

  has_many :replies, :as => :repliable, :order => :created_at, :dependent => :destroy
  has_many :repliers, :through => :replies, :uniq => true, :source => :user
  has_many :thanks, :as => :thankable, :dependent => :destroy
  has_many :warnings, :as => :warnable, :dependent => :destroy
  validates_presence_of :user, :community
  validates_presence_of :subject, :message => "Please enter a subject for your post"
  validates_presence_of :body, :message => "Please enter some text for your post"

  # default_scope where(:deleted_at => nil)

  attr_accessor :post_to_facebook

  scope :between, lambda { |start_date, end_date|
    { :conditions =>
      ["posts.created_at between ? and ?", start_date.utc, end_date.utc] }
  }
  scope :up_to, lambda { |end_date| { :conditions => ["posts.created_at <= ?", end_date.utc] } }

  scope :created_on, lambda { |date| { :conditions => ["posts.created_at between ? and ?", date.utc.beginning_of_day, date.utc.end_of_day] } }

  scope :core, {
    :joins => "LEFT OUTER JOIN users ON (posts.user_id = users.id) LEFT OUTER JOIN communities ON (users.community_id = communities.id)",
    :conditions => "communities.core = true",
    :select => "posts.*"
  }

  scope :today, :conditions => ["posts.created_at between ? and ?", DateTime.now.at_beginning_of_day, Time.now]

  scope :this_week, :conditions => ["posts.created_at between ? and ?", DateTime.now.at_beginning_of_week, Time.now]

  def has_reply
    self.replies.present?
  end

  def replied_at
    read_attribute(:replied_at) == nil ? self.updated_at : read_attribute(:replied_at)
  end

  def self.deleted
    self.unscoped.where('deleted_at IS NOT NULL')
  end

  def self.human_name
    "Neighborhood Post"
  end

  def owner
    self.user
  end

  def last_activity
    ([self.created_at] + self.replies.map(&:created_at)).max
  end

  def between?(start_date, end_date)
    start_date <= self.created_at and self.created_at <= end_date
  end

  def all_thanks
    (self.thanks + self.replies.map(&:thanks)).flatten.sort_by {|t| t.created_at }
  end

  def all_flags
    (self.warnings + self.replies.map(&:warnings)).flatten.sort_by { |t| t.created_at }
  end

  def is_publicity?
    self.category.present? and self.category == 'publicity'
  end

  acts_as_api

  api_accessible :history do |t|
    t.add :id
    t.add ->(m) { "posts" }, :as => :schema
    t.add :subject, :as => :title
  end

  searchable do
    text :subject, :body
    text :author_name do
      user.name
    end
    text :replies do
      replies.map &:body
    end
    text :reply_author do
      replies.map { |r| r.user.name }
    end
    integer :community_id
    integer :user_id
    integer :reply_author_ids, :multiple => true do
      replies.map { |r| r.user.id }
    end
    time :created_at
    string :category
  end

end
