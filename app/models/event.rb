class Event < ActiveRecord::Base

  require 'lib/helper'
  
  attr_accessor :pledge
  
  acts_as_taggable_on :tags

  validates_presence_of :name, :description, :date

  has_many :referrals
  has_many :replies, :as => :repliable
  has_many :repliers, :through => :replies, :uniq => true, :source => :user
  has_many :attendances
  has_many :attendees, :through => :attendances, :source => :user
  belongs_to :owner, :polymorphic => true

  has_many :invites, :as => :inviter

  has_one :location, :as => :locatable

  accepts_nested_attributes_for :location

  named_scope :upcoming, :conditions => ["? <= date", Time.now]
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
  
  def address
    self.location.street_address
  end

  def after_initialize
    unless self.location
      self.location = Location.new
    end
  end  
end
