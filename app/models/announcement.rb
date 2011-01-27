class Announcement < ActiveRecord::Base
  
  require "lib/helper"
  include IDEncoder

  has_many :replies, :as => :repliable
  has_many :repliers, :through => :replies, :uniq => true, :source => :user
  belongs_to :feed
  validates_presence_of :subject, :body, :feed, :unless => Proc.new { |announcement| announcement.type.to_s == 'TwitterAnnouncement'}
  
  def time
    help.post_date(self.created_at)
  end 
  
  def owner
    self.feed
  end
  
  def long_id
    IDEncoder.from_long_id(self.id)
  end
  
  def self.find_by_long_id(long_id)
    Announcement.find(IDEncoder.from_long_id(long_id))
  end

end
