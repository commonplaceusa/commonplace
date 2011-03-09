class Community < ActiveRecord::Base
  has_many :feeds
  has_many :neighborhoods, :order => :created_at
  has_many(:announcements, 
           :order => "announcements.created_at DESC",
           :include => [:feed, :replies])
  has_many(:events, 
           :order => "events.date ASC",
           :include => [:owner, :replies])

  has_many :users, :order => "last_name, first_name"

  has_many :groups

  has_many(:posts, 
           :order => "posts.updated_at DESC",
           :include => [:user, {:replies => :user}])
  
  
  validates_presence_of :name, :slug, :zip_code
  
  accepts_nested_attributes_for :neighborhoods

  has_attached_file(:logo,
                    :url => "/system/community/:id/logo.:extension",
                    :path => ":rails_root/public/system/community/:id/logo.:extension",
                    :default_url => "/images/logo.png")

  has_attached_file(:email_header,
                    :url => "/system/community/:id/email_header.:extension",
                    :path => ":rails_root/public/system/community/:id/email_header.:extension")

  has_attached_file(:organizer_avatar,
                    :url => "/system/community/:id/organizer_avatar.:extension",
                    :path => ":rails_root/public/system/community/:id/organizer_avatar.:extension",
                    :default_url => "/avatars/missing.png")

  def self.find_by_name(name)
    find(:first, :conditions => ["LOWER(name) = ?", name.downcase])
  end

  def self.find_by_slug(slug)
    find(:first, :conditions => ["LOWER(slug) = ?", slug.downcase])
  end
  
  def neighborhood_for(address)
    default = self.neighborhoods.first
    if position = LatLng.from_address(address, self.zip_code)
      self.neighborhoods.to_a.find(lambda { default }) do |n|
        n.contains?(position)
      end
    else
      default
    end
  end
    

end
