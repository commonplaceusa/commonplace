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
