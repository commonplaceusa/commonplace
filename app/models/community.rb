class Community < ActiveRecord::Base
  has_many :feeds
  has_many :neighborhoods, :order => :created_at
  has_many(:announcements,
           :order => "announcements.created_at DESC",
           :include => [:owner, :replies])
  has_many(:events, 
           :order => "events.date ASC",
           :include => [:owner, :replies])

  has_many :users, :order => "last_name, first_name"

  has_many :groups

  has_many(:posts, 
           :order => "posts.updated_at DESC",
           :include => [:user, {:replies => :user}])
  
  
  validates_presence_of :name, :slug
  
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
    where("LOWER(name) = ?", name.downcase).first
  end

  def self.find_by_slug(slug)
    where("LOWER(slug) = ?", slug.downcase).first
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

  def add_default_groups
    I18n.t("default_groups").each do |group|
      Group.create(:community => self,
                   :name => group['name'],
                   :about => group['about'].gsub("%{community_name}", self.name),
                   :avatar_url => group['avatar'],
                   :slug => group['slug'])
    end
    nil
  end

  # Convenience accessors for some mapped values
  def group_posts
    self.groups.map(&:group_posts).flatten
  end

  def group_posts_today
    group_posts.select { |post| post.created_at > DateTime.now.at_beginning_of_day and post.created_at < DateTime.now }
  end

  def private_messages
    self.users.map(&:messages).flatten
  end

  def private_messages_today
    private_messages.select { |message| message.created_at > DateTime.now.at_beginning_of_day and message.created_at < DateTime.now }
  end

  def completed_registrations
    # A registration is complete if the user has updated their data after the initial creation (incl. setting a password)
    User.where("created_at < updated_at AND community_id = ?", self.id)
  end

  def incomplete_registrations
    User.where("created_at >= updated_at AND community_id = ?", self.id)
  end

  def c(model)
    #count = 0
    #model.all.select { |o| o.owner.community_id == self.id }.each { |o| count += 1 }
    #count
    model.find(:all, :conditions => {:community_id => self.id }).count
  end

  def c_today(model)
    model.find(:all, :conditions => ["created_at between ? and ? AND community_id = ?", Date.today, DateTime.now, self.id]).count
  end

  def registrations_since_n_days_ago(days)
    registrations = []
    for i in (1..days)
      registrations.push(self.users.up_to(i.days.ago).count)
    end
    registrations.reverse
  end

  def since_n_days_ago(days,set,polymorphic=false)
    items = []
    for i in (1..days)
      if polymorphic
        items.push(set.created_on(i.days.ago).to_a.count)
      else
        items.push(set.created_on(i.days.ago).count)
      end
    end
    items.reverse
  end
  
  def private_messages_since_n_days_ago(day)
    items = []
    for i in (1..day)
      items.push(self.private_messages.select { |m| m.created_at >= day.days.ago.beginning_of_day and m.created_at <= day.days.ago.end_of_day } )
    end
    items.reverse
  end

  def to_param
    slug
  end
end
