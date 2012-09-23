class Announcement < ActiveRecord::Base
  include Trackable
  after_create :track_posted_content

  has_many :replies, :as => :repliable, :order => :created_at, :dependent => :destroy
  has_many :repliers, :through => :replies, :uniq => true, :source => :user
  belongs_to :owner, :polymorphic => true, :counter_cache => true
  belongs_to :community

  has_many :thanks, :as => :thankable, :dependent => :destroy


  has_many :announcement_cross_postings, :dependent => :destroy
  has_many :groups, :through => :announcement_cross_postings

  validates_presence_of :subject, :body

  scope :between, lambda { |start_date, end_date|
    { :conditions =>
      ["? <= announcements.created_at AND announcements.created_at < ?", start_date, end_date] }
  }
  scope :up_to, lambda { |end_date| { :conditions => ["announcements.created_at <= ?", end_date.utc] } }

  scope :created_on, lambda { |date| { :conditions => ["announcements.created_at between ? and ?", date.utc.beginning_of_day, date.utc.end_of_day] } }

  scope :today, :conditions => ["announcements.created_at between ? and ?", DateTime.now.at_beginning_of_day, DateTime.now]

  scope :this_week, :conditions => ["announcements.created_at between ? and ?", DateTime.now.at_beginning_of_week, DateTime.now]

  default_scope where(:deleted_at => nil)
  after_create :update_user_announcements_counter

  def has_reply
    self.replies.present?
  end

  def feed
    self.owner
  end

  def user
    if owner.is_a? Feed
      owner.user
    else
      owner
    end
  end

  def user_id
    user.id
  end

  def between?(start_date, end_date)
    start_date <= self.created_at and self.created_at <= end_date
  end

  def all_thanks
    (self.thanks + self.replies.map(&:thanks)).flatten.sort_by {|t| t.created_at }
  end

  acts_as_api

  api_accessible :history do |t|
    t.add :id
    t.add ->(m) { "announcements" }, :as => :schema
    t.add :subject, :as => :title
  end

  searchable do
    text :subject, :body
    text :replies do
      replies.map &:body
    end
    text :author_name do
      owner.name
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
  end

  def update_user_announcements_counter
    if self.owner_type=="Feed"
      @user=User.find(owner.user_id)
      @user.update_attribute(:announcements_count, @user.announcements_count+1)
    end
  end

end
