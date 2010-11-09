class Community < ActiveRecord::Base
  has_many :feeds
  has_many :neighborhoods
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

  def events
    (users.map{|u|u.direct_events} + feeds.map{|f|f.events.upcoming}).flatten.sort_by(&:start_datetime)
  end
end
