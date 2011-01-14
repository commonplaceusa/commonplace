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
  
end
