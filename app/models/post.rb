class Post < ActiveRecord::Base
  CATEGORIES = %w{Request Offer Invitation Announcement Question}  
  require "lib/helper"
  
  belongs_to :user

  has_many :replies, :as => :repliable
  has_many :repliers, :through => :replies, :uniq => true, :source => :user
  validates_presence_of :user
  validates_presence_of :body, :message => "Please enter some text for your post"

  def self.human_name
    "Neighborhood Post"
  end
  
  def time
    help.post_date self.created_at
  end
  
  def owner
    self.user
  end
  
end
