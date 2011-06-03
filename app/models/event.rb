class Event < ActiveRecord::Base

  
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

  scope :upcoming, lambda { { :conditions => ["? <= date", Time.now.beginning_of_day.utc] } }
  scope :between, lambda { |start_date, end_date| 
    { :conditions => ["? <= date AND date < ?", start_date, end_date] } 
  }
  scope :past, :conditions => ["date < ?", Time.now.utc]
  scope :today, :conditions => ["created_at between ? and ?", DateTime.now.at_beginning_of_day, DateTime.now]
  scope :up_to, lambda { |end_date| { :conditions => ["created_at <= ?", end_date.utc] } }

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
  
  def long_id
    IDEncoder.to_long_id(self.id)
  end
  
  def self.find_by_long_id(long_id)
    Event.find(IDEncoder.from_long_id(long_id))
  end
  
end
