class Event < ActiveRecord::Base

  require 'lib/helper'
  
  attr_accessor :pledge
  
  acts_as_taggable_on :tags

  validates_presence_of :name, :description, :date
  validates_uniqueness_of :source_feed_id, :if => Proc.new { |event| event.owner_type == "Feed" && event.source_feed_id }

  has_many :referrals
  has_many :replies, :as => :repliable
  has_many :repliers, :through => :replies, :uniq => true, :source => :user
  has_many :attendances
  has_many :attendees, :through => :attendances, :source => :user
  belongs_to :owner, :polymorphic => true

  has_many :invites, :as => :inviter

  named_scope :upcoming, :conditions => ["? <= date", Time.now.beginning_of_day]
  named_scope :past, :conditions => ["date < ?", Time.now]

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
    # Return the base-64 encoded post ID, replacing any tailing = characters with their quantity
    require 'base64'
    long_id = Base64.b64encode(self.id.to_s)
     m = long_id.match(/[A-Za-z0-9]*(=*)/)
    
    if m[1]
      long_id = long_id.gsub(m[1],m[1].length.to_s)
    end
    long_id.gsub("\n","")
  end
  
  def self.find_by_long_id(long_id)
    # Decode the base-64 encoding done in Post.long_id, and get the post
    require 'base64'
    # Reconstruct the equal signs at the end
    num = long_id[long_id.length-1,long_id.length-1]
    long_id = long_id[0,long_id.length-1]
    num.to_i.times do |i|
      long_id += "="
    end
    # Find the post
    event_id = Base64.decode64(long_id)
    Event.find(event_id)
  end
  
end
