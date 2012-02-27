class Swipe < ActiveRecord::Base

  belongs_to :feed
  
  belongs_to :user
  
  validates_presence_of :feed
  validates_presence_of :user
  
  attr_accessor :feed_pwd
  
  def success
    self.persisted? and self.feed_pwd == self.feed.password
  end
  
  def reason
    if self.success
      nil
    elsif self.user.nil?
      "user doesn't exist"
    elsif self.feed.nil?
      "feed doesn't exist"
    else
      "unknown errors"
    end
  end
  
end
