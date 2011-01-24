class Community < ActiveRecord::Base
  has_many :feeds
  has_many :neighborhoods, :order => :created_at
  has_many(:announcements, 
           :through => :feeds, 
           :order => "announcements.created_at DESC",
           :include => [:feed, :replies])

  has_many :users, :order => "last_name, first_name"

  has_many :feed_events, :through => :feeds, :source => :events
  has_many :user_events, :through => :users, :source => :direct_events

  has_many(:community_posts, 
           :order => "created_at DESC", 
           :include => {:replies => :user},
           :as => :area,
           :class_name => "Post")
  
  
  validates_presence_of :name, :slug, :zip_code
  
  accepts_nested_attributes_for :neighborhoods

  has_attached_file(:logo,
                    :url => "/system/community/:id/logo.:extension",
                    :path => ":rails_root/public/system/community/:id/logo.:extension",
                    :default_url => "/images/logo.png")

  has_attached_file(:email_header,
                    :url => "/system/community/:id/email_header.:extension",
                    :path => ":rails_root/public/system/community/:id/email_headero.:extension")

  def posts
    neighborhoods.map(&:posts).flatten
  end

  def self.find_by_name(name)
    find(:first, :conditions => ["LOWER(name) = ?", name.downcase])
  end

  def self.find_by_slug(slug)
    find(:first, :conditions => ["LOWER(slug) = ?", slug.downcase])
  end
  
  def events
    (user_events.upcoming + feed_events.upcoming).sort_by(&:start_datetime)
  end
end
