class Post < ActiveRecord::Base
  CATEGORIES = %w{Request Offer Invitation Announcement Question}  
  require "lib/helper"
  
  belongs_to :user

  has_many :replies, :as => :repliable
  has_many :repliers, :through => :replies, :uniq => true, :source => :user
  validates_presence_of :user
  validates_presence_of :subject, :message => "Please enter a subject for your post"
  validates_presence_of :body, :message => "Please enter some text for your post"


  has_many :notifications, :as => :notified

  def self.human_name
    "Neighborhood Post"
  end
  
  def long_id
    # Return the base-64 encoded post ID, replacing any tailing = characters with their quantity
    require 'base64'
    long_id = Base64.b64encode(self.id.to_s)
    m = long_id.match(/[A-Za-z0-9]*(=+)/)
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
    post_id = Base64.decode64(long_id)
    Post.find(post_id)
  end
  
  def category
    super || "Announcement"
  end
  
  def time
    help.post_date(self.created_at)
  end
  
  def owner
    self.user
  end
  
  def user_may_delete(current_user)
    return current_user.is_same_as(self.user)
  end
  
  def deleteLink
    if self.user_may_delete(UserSession.find.user)
      "<a href='/posts/destroy/#{self.id}'><img src='/images/delete.png' /></a>"
    else
      ""
    end
  end
    
  
end
