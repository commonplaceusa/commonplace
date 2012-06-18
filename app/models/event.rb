class Event < ActiveRecord::Base
  #track_on_creation


  attr_accessor :pledge

  validates_presence_of :name, :description, :date
  validates_uniqueness_of :source_feed_id, :if => Proc.new { |event| event.owner_type == "Feed" && event.source_feed_id }

  has_many :referrals
  has_many :replies, :as => :repliable, :order => :created_at, :dependent => :destroy
  has_many :repliers, :through => :replies, :uniq => true, :source => :user
  has_many :attendances
  has_many :attendees, :through => :attendances, :source => :user

  has_many :event_notes

  belongs_to :owner, :polymorphic => true
  belongs_to :community

  has_many :thanks, :as => :thankable, :dependent => :destroy

  has_many :invites, :as => :inviter

  has_many :event_cross_postings, :dependent => :destroy
  has_many :groups, :through => :event_cross_postings

  scope :upcoming, lambda { { :conditions => ["? <= events.date", Time.now.beginning_of_day.utc] } }
  scope :between, lambda { |start_date, end_date|
    { :conditions => ["? <= events.date AND events.date < ?", start_date, end_date] }
  }

  scope :core, {
    :joins => "LEFT OUTER JOIN users ON (events.owner_id = users.id) LEFT OUTER JOIN communities ON (users.community_id = communities.id)",
    :conditions => "communities.core = true",
    :select => "events.*"
  }

  scope :past, :conditions => ["events.date < ?", Time.now.utc]
  scope :today, :conditions => ["events.created_at between ? and ?", DateTime.now.at_beginning_of_day, DateTime.now]
  scope :this_week, :conditions => ["events.created_at between ? and ?", DateTime.now.at_beginning_of_week, Time.now]
  scope :up_to, lambda { |end_date| { :conditions => ["events.created_at <= ?", end_date.utc] } }

  scope :created_on, lambda { |date| { :conditions => ["events.created_at between ? and ?", date.utc.beginning_of_day, date.utc.end_of_day] } }

  default_scope where(:deleted_at => nil)

  acts_as_api

  api_accessible :history do |t|
    t.add :id
    t.add ->(m) { "events" }, :as => :schema
    t.add :name, :as => :title
  end

  def has_reply
    self.replies.present?
  end

  def replied_at
    read_attribute(:replied_at) == nil ? self.updated_at : read_attribute(:replied_at)
  end

  def tag_list
    self.cached_tag_list
  end

  def tag_list=(string)
    self.cached_tag_list= string
  end

  def search(term)
    Event.all
  end

  def time
    date.strftime("%b %d")
  end

  def occurs_at
    DateTime.strptime("#{self.date.strftime("%Y-%m-%d")}T00:00:00#{Time.zone.formatted_offset}")
  end

  def start_datetime
    date.to_time + start_time.hour.hours + start_time.min.minutes
  end

  def subject
    self.name
  end

  def body
    self.description
  end

  def user
    case owner
      when User then owner
      when Feed then owner.user
    end
  end

  def user_id
    user.id
  end

  def between?(start_date, end_date)
    start_date <= self.created_at and self.created_at <= end_date
  end

  def long_id
    IDEncoder.to_long_id(self.id)
  end

  def self.find_by_long_id(long_id)
    Event.find(IDEncoder.from_long_id(long_id))
  end

  def all_thanks
    (self.thanks + self.replies.map(&:thanks)).flatten.sort_by {|t| t.created_at }
  end

  searchable do
    text :name, :description, :venue, :address
    text :replies do
      replies.map &:body
    end
    text :reply_author do
      replies.map { |r| r.user.name }
    end
    text :author_name do
      owner.name
    end
    time :date
    integer :community_id
    integer :user_id
    integer :reply_author_ids, :multiple => true do
      replies.map { |r| r.user.id }
    end
    time :created_at
  end

end
