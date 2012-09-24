class Community < ActiveRecord::Base
  serialize :metadata, Hash
  serialize :feature_switches, Hash
  serialize :discount_businesses

  has_many :feeds
  has_many :stories
  has_many :neighborhoods, :order => :created_at
  has_many(:announcements,
           :order => "announcements.created_at DESC",
           :include => [:replies])
  has_many(:events,
           :order => "events.date ASC",
           :include => [:replies])

  has_many :users, :order => "last_name, first_name"
  has_many :mets, :through => :users
  has_many :residents
  has_many :street_addresses
  def organizers
    self.users.select { |u| u.admin }
  end

  has_many :groups
  has_many :group_posts, :through => :groups

  has_many :messages, :through => :users
  has_many :subscriptions, :through => :users

  has_many(:posts,
           :order => "posts.updated_at DESC",
           :include => [:user, {:replies => :user}])

  before_destroy :ensure_marked_for_deletion

  validates_presence_of :name, :slug
  validates_uniqueness_of :slug

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
    t.add :state
    t.add :locale
    t.add :groups
    t.add :organizer_name, :as => :admin_name
    t.add :organizer_email, :as => :admin_email
    t.add :links
    t.add :discount_businesses
    t.add lambda {|c| $goods }, :as => :goods
    t.add lambda {|c| $skills }, :as => :skills
    t.add lambda {|c| $interests }, :as => :interests
    t.add :resident_tags
    t.add :manual_tags
    t.add :resident_todos
    t.add :zip_code
    t.add :organize_start_date
    t.add :scripts
    t.add :user_count
    t.add :feed_count
    #t.add lambda {|u| u.user_statistics}, :as => :user_statistics
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
      "residents" => "/communities/#{id}/residents",
      "email_contact_authorization_callback" => "find_neighbors/callback",
      "facebook_login" => "/users/auth/facebook",
      "registration" => {
        "validate" => "/registration/#{id}/validate",
        "new" => "/registration/#{id}/new",
        "avatar" => "/account/avatar",
        "facebook" => "/registration/#{id}/facebook",
        "residents" => "/communities/#{id}/residents"
      }
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

  def add_default_groups!
    I18n.t("default_groups").each do |group|
      Group.create(:community => self,
                   :name => group['name'],
                   :about => group['about'].gsub("%{community_name}", self.name),
                   :avatar_url => "https://s3.amazonaws.com/commonplace-avatars-production/groups/#{group['slug']}.png",
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
    :en
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

  def add_resident_tags(tags)
    self.metadata[:resident_tags] ||= []
    self.metadata[:resident_tags] |= tags

    self.save
  end

  def add_resident_todos(todos)
    self.metadata[:resident_todos] ||= []
    self.metadata[:resident_todos] |= todos
    self.save
  end

  def scripts
    scripts = Flag.get_scripts
    scripts
  end

  def user_count
    self.users.count
  end

  def feed_count
    self.feeds.count
  end

  def resident_todos
    todos = Flag.get_todos
    todos |= self.metadata[:resident_todos] if self.metadata[:resident_todos]
    todos
  end

  def resident_tags
    tags = Flag.get_types.keys
    tags |=  self.metadata[:resident_tags] if self.metadata[:resident_tags]
    tags |= self.exterior.referral_sources.reject {|ref| ref == ""}.map {|ref| "Referral: " << ref}
    tags |= Array("Joined CP")
    tags
  end

  def manual_tags
    Flag.all.map &:name
  end

  # Calculates datas over time and data per day for graphs in Organizer App
  #
  def graph(datas)
    if self.organize_start_date?
      start = self.organize_start_date
    else
      start = self.created_at.to_date
    end

    if Date.today.months_ago(6) > start
      t = Date.today.months_ago(6)
    else
      t = start
    end

    # Sort data by time of creation
    data = datas.sort { |x,y| x.created_at <=> y.created_at }

    table = []
    table << ["Date","Total","Gain"]

    total = 0
    gain = 0
    data.each do |d|

      # Add to counts until d was created after time t
      if d.created_at.to_date <= t
        gain += 1
        total += 1

        if d.id != data.last.id
          next
        end
      else
        # d is created after time t. Record counts for time t
        table << [t.strftime("%b %d"), total, gain]
        gain = 0
        t += 1

        # Increment t until t is the day that d was created at
        # Record total for each t until then
        while d.created_at.to_date > t

          table << [t.strftime("%b %d"), total, 0]

          t += 1
        end

        # Reached time of creation of d. Start counting again
        gain += 1
        total += 1
      end

      # Last piece of data, so record counts
      if d.id == data.last.id

        table << [t.strftime("%b %d"), total, gain]
        t += 1
      end
    end

    while t <= Date.today
      table << [t.strftime("%b %d"), total, 0]

      t += 1
    end

    table
  end

  def user_charts
    charts = {}
    residents = self.residents.all.reject { |x| x.metadata[:tags].nil? }

    # Platform data
    platform = []
    platform << ["Users", "Posts", "Events"]

    users = self.users.count
    posts = self.posts.count
    events = self.events.count

    platform << [users, posts, events]

    # Civic Leader Track data
    leader = []
    leader << ["Total # of Civic Leaders", "Total # of Asks Phone Calls", "Total # of Yes", "Total # of PFOs",
      "Total # of Non-PFOs", "Total # of Civic Leaders who joined CP", "Total # of Civic Leaders who have a feed", "Total # of Civic Leaders who have posted to their feed"]

    leaders = residents.reject { |x| !x.metadata[:tags].include?("Type: Civic Leader") }

    c_leaders = leaders.count
    calls =  residents.reject { |x| !x.metadata[:tags].include?("CL2: Civic Leader Phone Call Held") }.count
    yes = residents.reject { |x| !x.metadata[:tags].include?("Type: Civic Leader Partner") }.count
    pfos = residents.reject { |x| !x.metadata[:tags].include?("Type: PFO") }.count
    nonPFOs = residents.reject { |x| !x.metadata[:tags].include?("Type: Non-PFO") }.count
    joined = leaders.reject { |x| !x.metadata[:tags].include?("Joined CP") }.count
    feeds = leaders.reject { |x| !x.metadata[:tags].include?("Feed Owner") }.count
    posted = leaders.reject { |x| !x.metadata[:tags].include?("Has Posted") }.count

    leader << [c_leaders, calls, yes, pfos, nonPFOs, joined, feeds, posted]

    # Civic Hero Track data
    hero = []
    hero << ["Total On Civic Heroes Track", "# of people interviewed", "People added to Civic Hero List", "Nominees", "Nominees Responded",
      "Nominees Processed", "Nominees Joined", "Nominators", "Nominators who joined"]

    nominees = residents.reject { |x| !x.metadata[:tags].include?("Type: Nominee") }
    nominators = residents.reject { |x| !x.metadata[:tags].include?("Type: Nominator") }

    heroes = residents.reject { |x| !x.metadata[:tags].include?("Type: Civic Hero Partner") }.count
    interviewed = residents.reject { |x| !x.metadata[:tags].include?("CH3a: Interviewed") }.count
    listed = residents.reject { |x| !x.metadata[:tags].include?("On Civic Heroes List") }.count
    c_nominees = nominees.count
    responded = residents.reject { |x| !x.metadata[:tags].include?("CH1: Responded to Civic Hero Asks Email") }.count
    processed = nominees.reject { |x| !x.metadata[:tags].include?("Type: Civic Hero Partner") }.count
    j_nominees = nominees.reject { |x| !x.metadata[:tags].include?("Joined CP") }.count
    c_nominators = nominators.count
    j_nominators = nominators.reject { |x| !x.metadata[:tags].include?("Joined CP") }.count

    hero << [heroes, interviewed, listed, c_nominees, responded, processed, j_nominees, c_nominators, j_nominators]

    # Other Tracks
    other = []
    other << ["", "Super Leaders", "Gatekeeper", "Library/CC", "Total # of Press", "Total # of Student Organizer Recruiter"]

    ts_leaders = residents.reject { |x| !x.metadata[:tags].include?("Type: Super Leader") }.count
    t_gate = residents.reject { |x| !x.metadata[:tags].include?("Type: Gatekeeper") }.count
    t_cc = residents.reject { |x| !x.metadata[:tags].include?("Type: Library/CC") }.count
    t_press = residents.reject { |x| !x.metadata[:tags].include?("Type: Press") }.count
    t_student = residents.reject { |x| !x.metadata[:tags].include?("Type: Student Organizer Recruiter") }.count
    ps_leaders = residents.reject { |x| !x.metadata[:tags].include?("Type: Super Leader Partner") }.count
    p_gate = residents.reject { |x| !x.metadata[:tags].include?("Type: Gatekeeper Partner") }.count
    p_cc = residents.reject { |x| !x.metadata[:tags].include?("Type: Library/CC Partner") }.count
    p_press = residents.reject { |x| !x.metadata[:tags].include?("Type: Press Partner") }.count
    p_student = residents.reject { |x| !x.metadata[:tags].include?("Type: Student Organizer Recruiter Partner") }.count

    other << ["Total #", ts_leaders, t_gate, t_cc, t_press, t_student]
    other << ["# of Partners", ps_leaders, p_gate, p_cc, p_press, p_student]

    # Launch Email Response Rate
    launch = []
    launch << ["", "Nomination Email A", "Nomination Email B", "Nomination Drive Email (To Leaders)", "Civic Leader Tips Email", "Civic Leader Phone Call Request A"]

    # All the data
    charts.merge!({ platform: platform })
    charts.merge!({ leader: leader })
    charts.merge!({ hero: hero })
    charts.merge!({ other: other })
  end

  def user_statistics
    result = {}
    residents = self.residents.all

    civic_l = residents.reject { |x| x.metadata[:tags].nil? || !x.metadata[:tags].include?("Type: Civic Leader") }.map { |x| x.id }
    civics_l = Flag.where("name = ? AND resident_id in (?)", "CL2: Civic Leader Phone Call Held", civic_l)

    civic_p = residents.reject { |x| x.metadata[:tags].nil? || !x.metadata[:tags].include?("CH3a: Post Published") }.map { |x| x.id }
    civics_p = Flag.where("name = ? AND resident_id in (?)", "CH3a: Post Published", civic_p)

    civic_s = residents.reject { |x| x.metadata[:tags].nil? || !x.metadata[:tags].include?("Status: On Civic Heroes List") }.map { |x| x.id }
    civics_s = Flag.where("name = ? AND resident_id in (?)", "Status: On Civic Heroes List", civic_s)

    nominee_r = residents.reject { |x| x.metadata[:tags].nil? || !x.metadata[:tags].include?("Type: Nominee") }.map { |x| x.id }
    nominee = Flag.where("name = ? AND resident_id in (?)", "Type: Nominee", nominee_r)

    nominator_r = residents.reject { |x| x.metadata[:tags].nil? || !x.metadata[:tags].include?("Type: Nominator") }.map { |x| x.id }
    nominator = Flag.where("name = ? AND resident_id in (?)", "Type: Nominator", nominator_r)

    phone = graph(civics_l)
    posted = graph(civics_p)
    status = graph(civics_s)

    nominees = graph(nominee)
    nominators = graph(nominator)

    users = graph(self.users.all)
    posts = graph(self.posts.all)
    events = graph(self.events.all)

    result.merge!({users: users})
    result.merge!({posts: posts})
    result.merge!({events: events})
    result.merge!({phone: phone})
    result.merge!({posted: posted})
    result.merge!({c_status: status})
    result.merge!({nominees: nominees})
    result.merge!({nominators: nominators})
  end
end
