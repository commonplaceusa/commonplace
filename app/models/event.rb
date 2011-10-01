class Event < ActiveRecord::Base
  #track_on_creation

  
  attr_accessor :pledge

  validates_presence_of :name, :description, :date
  validates_uniqueness_of :source_feed_id, :if => Proc.new { |event| event.owner_type == "Feed" && event.source_feed_id }

  has_many :referrals
  has_many :replies, :as => :repliable, :order => :created_at
  has_many :repliers, :through => :replies, :uniq => true, :source => :user
  has_many :attendances
  has_many :attendees, :through => :attendances, :source => :user
  belongs_to :owner, :polymorphic => true
  belongs_to :community

  has_many :invites, :as => :inviter

  has_many :event_cross_postings
  has_many :groups, :through => :event_cross_postings

  scope :upcoming, lambda { { :conditions => ["? <= events.date", Time.now.beginning_of_day.utc] } }
  scope :between, lambda { |start_date, end_date| 
    { :conditions => ["? <= events.date AND events.date < ?", start_date, end_date] } 
  }
  scope :past, :conditions => ["events.date < ?", Time.now.utc]
  scope :today, :conditions => ["events.created_at between ? and ?", DateTime.now.at_beginning_of_day, DateTime.now]
  scope :up_to, lambda { |end_date| { :conditions => ["events.created_at <= ?", end_date.utc] } }

  scope :created_on, lambda { |date| { :conditions => ["events.created_at between ? and ?", date.utc.beginning_of_day, date.utc.end_of_day] } }

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
  
  def long_id
    IDEncoder.to_long_id(self.id)
  end
  
  def self.find_by_long_id(long_id)
    Event.find(IDEncoder.from_long_id(long_id))
  end
  
end
