class Announcement < ActiveRecord::Base
  
  require "lib/helper"

  has_many :replies, :as => :repliable
  has_many :repliers, :through => :replies, :uniq => true, :source => :user
  belongs_to :feed
  validates_presence_of :subject, :body, :feed
  
  def time
    help.post_date(self.created_at)
  end 
  
  def owner
    self.feed
  end

end
