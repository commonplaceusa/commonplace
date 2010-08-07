class Announcement < ActiveRecord::Base
  
  require "lib/helper"
  
  belongs_to :organization
  validates_presence_of :subject, :body
  
  def time
    help.post_date self.created_at
  end 
  
  def owner
    self.organization
  end
  
  # this will be real!
  def reply_count
    "2&nbsp;replies"
  end
  
end
