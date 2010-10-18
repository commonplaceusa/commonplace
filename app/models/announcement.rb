class Announcement < ActiveRecord::Base
  
  require "lib/helper"

  has_many :replies, :as => :repliable
  has_many :repliers, :through => :replies, :uniq => true, :source => :user
  belongs_to :organization
  validates_presence_of :subject, :body
  
  def time
    help.post_date(self.created_at)
  end 
  
  def owner
    self.organization
  end

end
