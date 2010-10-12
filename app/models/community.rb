class Community < ActiveRecord::Base
  has_many :organizations
  has_many :neighborhoods
  has_many :events, :through => :organizations
  has_many :announcements, :through => :organizations


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
