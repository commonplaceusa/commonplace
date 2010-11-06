class Community < ActiveRecord::Base
  has_many :feeds
  has_many :neighborhoods
  has_many :events, :through => :feeds
  has_many :announcements, :through => :feeds


  def posts
    neighborhoods.map(&:posts).flatten
  end

  def self.find_by_name(name)
    find(:first, :conditions => ["LOWER(name) = ?", name.downcase])
  end

  def users
    neighborhoods.map(&:users).flatten
  end
end
