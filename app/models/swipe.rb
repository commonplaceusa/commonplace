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
    elsif self.feed_pwd != self.feed.password
      "invalid password"
    else
      "unknown errors"
    end
  end
  
  acts_as_api
  
  api_accessible :default do |t|
    t.add lambda {|s| true }, :as => :success
    t.add lambda {|s| s.user.name }, :as => :user
    t.add :user_id
    t.add lambda {|s| s.feed.name }, :as => :feed
    t.add :feed_id
    t.add lambda {|s| s.created_at.utc }, :as => :published_at
    t.add :links
  end
  
  api_accessible :error do |t|
    t.add lambda {|s| false }, :as => :success
    t.add :reason
  end
  
  def links
    {
      "feed_swipes" => "/feed/#{self.feed_id}/swipes",
      "user_swipes" => "/account/swipes"
    }
  end
  
end
