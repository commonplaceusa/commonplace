class Community < ActiveRecord::Base

  serialize :discount_businesses
  has_many :feeds
  has_many :neighborhoods, :order => :created_at
  has_many(:announcements,
           :order => "announcements.created_at DESC",
           :include => [:replies])
  has_many(:events, 
           :order => "events.date ASC",
           :include => [:replies])

  has_many :users, :order => "last_name, first_name"
  has_many :residents
  def organizers
    self.users.select { |u| u.admin }
  end

  has_many :groups
  has_many :group_posts, :through => :groups

  has_many :messages, :through => :users

  has_many(:posts, 
           :order => "posts.updated_at DESC",
           :include => [:user, {:replies => :user}])
  
  before_destroy :ensure_marked_for_deletion
  
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

  acts_as_api

  api_accessible :default do |t|
    t.add :id
    t.add :name
    t.add :slug
    t.add :locale
    t.add :groups
    t.add :organizer_name, :as => :admin_name
    t.add :organizer_email, :as => :admin_email
    t.add :links
    t.add :discount_businesses
    t.add lambda {|c| $goods }, :as => :goods
    t.add lambda {|c| $skills }, :as => :skills
    t.add lambda {|c| $interests }, :as => :interests
  end

  def links
    community_asset_url = "https://s3.amazonaws.com/commonplace-community-assets/#{slug}/"
    {
      "base" => "http://#{ENV['domain'] || 'localhost:3000'}/#{slug}",
      "launch_letter" => community_asset_url + "launchletter.pdf",
      "information_sheet" => community_asset_url + "infosheet.pdf",
      "neighborhood_flyer" => community_asset_url + "neighborflyer.pdf",
      "all_flyers" => community_asset_url + "archives.zip",
      "groups" => "/communities/#{id}/groups",
      "feeds" => "/communities/#{id}/feeds",
      "posts" => "/communities/#{id}/posts",
      "events" => "/communities/#{id}/events",
      "announcements" => "/communities/#{id}/announcements",
      "group_posts" => "/communities/#{id}/group_posts",
      "post_likes" => "/communities/#{id}/post-like",
      "posts_and_group_posts" => "/communities/#{id}/posts_and_group_posts",
      "group_likes" => "/communities/#{id}/group-like",
      "users" => "/communities/#{id}/users",
      "featured_users" => "/communities/#{id}/users/featured",
      "featured_feeds" => "/communities/#{id}/feeds/featured",
      "self" => "/communities/#{id}",
      "posts_neighborhood" => "/communities/#{id}/posts/neighborhood",
      "posts_offers" => "/communities/#{id}/posts/offers",
      "posts_help" => "/communities/#{id}/posts/help",
      "posts_publicity" => "/communities/#{id}/posts/publicity",
      "posts_other" => "/communities/#{id}/posts/other",
      "posts_meetups" => "/communities/#{id}/posts/meetups",
      "invites" => "/communities/#{id}/invites",
      "questions" => "/communities/#{id}/questions",
      "shares" => "/communities/#{id}/shares",
      "landing_wires" => "/communities/#{id}/wire",
      "residents" => "/communities/#{id}/residents"
    }
  end

  def self.find_by_name(name)
    where("LOWER(name) = ?", name.downcase).first
  end

  def self.find_by_slug(slug)
    where("LOWER(slug) = ?", slug.downcase).first
  end

  def ensure_marked_for_deletion
    raise "Can not destroy community" unless self.should_delete
  end
  
  def neighborhood_for(address)
    if self.is_college
      self.neighborhoods.select { |n| n.name == address }
    else
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

  def group_posts_today
    group_posts.select { |post| post.created_at > DateTime.now.at_beginning_of_day and post.created_at < DateTime.now }
  end

  def private_messages
    self.messages
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

  def locale
    (self.is_college) ? :college : :en
  end

  def posts_for_user(user)
    if user.community.is_college
      Post.includes(:user).where(:users => { :neighborhood_id => user.neighborhood_id})
      user.neighborhood.posts
    else
      user.community.posts
    end
  end

  def user_growth_since_launch_as_csv
    StatisticsAggregator.generate_statistics_for_community(c)
  end

  def launch_date
    self.read_attribute(:launch_date) || self.created_at
  end

  def has_launched?
    self.launch_date < DateTime.now
  end
  
  def user_count
    self.users.count
  end

  def total_replies
    self.users.sum("replies_count").to_i
  end

  def repliables
    [self.posts + self.events + self.announcements + self.private_messages + self.group_posts]
  end

  def replies_this_week
    Reply.joins(:user)
      .where(:users => { :community_id => self.id })
      .where("replies.created_at >= ?", DateTime.now.beginning_of_week).count
  end

  def wire
    CommunityWire.new(self)
  end
  
  def exterior
    CommunityExterior.new(self)
  end

end
