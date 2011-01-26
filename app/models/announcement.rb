class Announcement < ActiveRecord::Base
  
  require "lib/helper"

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
    # Return the base-64 encoded post ID, replacing any tailing = characters with their quantity
    require 'base64'
    long_id = Base64.b64encode(self.id.to_s)
     m = long_id.match(/[A-Za-z0-9]*(=*)/)
    
    if m[1].present?
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
    announcement_id = Base64.decode64(long_id)
    Announcement.find(announcement_id)
  end

end
