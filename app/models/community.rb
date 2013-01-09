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

  has_many :transactions
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
      "transactions" => "/communities/#{id}/transactions",
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
    tags |= Array("Status: Joined CP")

    self.feeds.each do |f|
      tags |= Array("Member: " + f.name)
      tags |= Array("Subscriber: " + f.name)
    end
    tags
  end

  def manual_tags
    #Flag.all.map &:name
    []
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
    residents = self.residents.all.reject { |x| x.tags.nil? || x.tags.count == 0 }
    headers = ["Type", "#", "Conversion Rate"]

    def percent(n, d)
      if d == 0
        return 0.0
      end

      (n.to_f / d * 100 * 100).round * 0.01
    end

    def rejectx(list)
      list.reject { |x| x.tags.include?("X: Referred Out") || x.tags.include?("X: Uninterested") }
    end

    # Leaders Metrics
    leaders = residents.reject { |x| !x.tags.include?("Type: Leader") }

    # Recruiting Leaders
    r_leaders = []
    r_leaders << headers

    conn = leaders.reject { |x| !x.tags.include?("L1: Contacted") }
    p_conn = rejectx(conn).reject { |x| x.tags.include?("L1x: No Email") || x.tags.include?("L2: Connected") }
    no_resp = rejectx(p_conn).reject { |x| x.tags.include?("L1x: Delayer") }
    delayers = rejectx(leaders).reject { |x| !x.tags.include?("L1x: Delayer") || x.tags.include?("L2: Connected") }

    ref_out = leaders.reject { |x| !x.tags.include?("X: Referred Out") }
    uninterest = leaders.reject { |x| !x.tags.include?("X: Uninterested") }
    no_email = leaders.reject { |x| !x.tags.include?("L1x: No Email") }
    c_leaders = ref_out | uninterest | no_email

    tlaunch = conn.reject { |x| !x.tags.include?("L2: Connected") }
    tsuccess = leaders.reject { |x| !x.tags.include?("Email: Leader Non-Responder 1: Success") }
    tpersonal = leaders.reject { |x| !x.tags.include?("Email: Leader Non-Responder 2: Personal") }
    tlast_chance = leaders.reject { |x| !x.tags.include?("Email: Leader Non-Responder 3: Last Chance") }

    l_conn = rejectx(tlaunch).reject { |x| x.tags.include?("Type: Leader Partner") }
    last_chance = tlaunch & tlast_chance
    personal = tlaunch & tpersonal - last_chance
    success = tlaunch & tsuccess - personal
    launch = tlaunch - success

    leader_p = leaders.reject{ |x| !x.tags.include?("Type: Leader Partner") }

    l_count = leaders.count
    p_conn = p_conn.count
    no_resp = no_resp.count
    delayers = delayers.count
    c_leaders = c_leaders.count
    l_conn = l_conn.count
    launch = launch.count
    success = success.count
    personal = personal.count
    last_chance = last_chance.count
    leader_p = leader_p.count

    a = percent(p_conn, l_count)
    b = percent(c_leaders, l_count)
    c = percent(l_conn, l_count)
    d = percent(launch, conn.count)
    e = percent(success, tsuccess.count)
    f = percent(personal, tpersonal.count)
    g = percent(last_chance, tlast_chance.count)
    h = percent(leader_p, l_count)

    r_leaders << ["Mapped Leaders", l_count, "Exactly what you'd expect"]
    r_leaders << ["Possible Connections", p_conn, a.to_s + "% of total mapped leaders"]
    r_leaders << ["==> Non-Responders", no_resp]
    r_leaders << ["==> Delayers", delayers]
    r_leaders << ["Closed Leaders", c_leaders, b.to_s + "% of total mapped leaders"]
    r_leaders << ["==> Referred Out", ref_out.count]
    r_leaders << ["==> Uninterested", uninterest.count]
    r_leaders << ["==> Dead Email", no_email.count]
    r_leaders << ["Live Connections", l_conn, c.to_s + "% of total mapped leaders"]
    r_leaders << ["==> Launch Email", launch, d.to_s + "% of total emailed Launch Email"]
    r_leaders << ["==> Success Email", success, e.to_s + "% of total emailed Success Email"]
    r_leaders << ["==> Personal Email", personal, f.to_s + "% of total emailed Personal Email"]
    r_leaders << ["==> Last Chance Email", last_chance, g.to_s + "% of total emailed Last Chance Email"]
    r_leaders << ["Leader Partners", leader_p, h.to_s + "% of total mapped leaders"]

    # Activating Leaders
    a_leaders = []
    a_leaders << headers

    conn = leaders.reject { |x| !x.tags.include?("L2: Connected") }
    scheduled = conn.reject { |x| !x.tags.include?("L3: Call Scheduled") }
    held = scheduled.reject { |x| !x.tags.include?("L4: Call Held") }
    l_partners = leaders.reject { |x| !x.tags.include?("Type: Leader Partner") }

    feed_ask = leaders.reject { |x| !x.tags.include?("Ask: Wants Feed") }
    feed_create = leaders.reject { |x| !x.tags.include?("Status: Transferred Feed") }
    cards = leaders.reject { |x| !x.tags.include?("Status: Cards Sent") }
    blurbs = leaders.reject { |x| !x.tags.include?("Status: Blurb Sent") }
    focp = leaders.reject { |x| !x.tags.include?("Status: Friend of OurCommonPlace") }
    reasons = leaders.reject { |x| !x.tags.include?("Status: 50 Reasons Post Published") }
    follow = leaders.reject { |x| !x.tags.include?("Status: Followed Up") }

    conn = conn.count
    scheduled = scheduled.count
    held = held.count
    l_partners = l_partners.count
    feed_ask = feed_ask.count
    feed_create = feed_create.count
    cards = cards.count
    blurbs = blurbs.count
    focp = focp.count
    reasons = reasons.count
    follow = follow.count

    a = percent(scheduled, conn)
    b = percent(held, conn)
    c = percent(l_partners, conn)

    a_leaders << ["Connected Leaders", conn, "Like, seriously"]
    a_leaders << ["Calls Scheduled", scheduled, a.to_s + "%"]
    a_leaders << ["Call Held", held, b.to_s + "%"]
    a_leaders << ["Leader Partners", l_partners, c.to_s + "%"]
    a_leaders << ["Feeds Asked For", feed_ask]
    a_leaders << ["Feeds Created", feed_create]
    a_leaders << ["Cards Sent", cards]
    a_leaders << ["Blurbs Sent", blurbs]
    a_leaders << ["Friends of CommonPlace", focp]
    a_leaders << ["50 Reasons Published", reasons]
    a_leaders << ["Follow Ups", follow]

    # Excited Neighbors Metrics
    neighbors = residents.reject { |x| !x.tags.include?("Type: Excited Neighbor") }

    # Recruiting Excited Neighbors
    r_neighbors = []
    r_neighbors << headers

    conn = neighbors.reject { |x| !x.tags.include?("EN1: Contacted") }
    p_conn = rejectx(conn).reject { |x| x.tags.include?("EN1x: No Email") || x.tags.include?("EN2: Connected") }
    no_resp = rejectx(p_conn).reject { |x| x.tags.include?("EN1x: Delayer") }
    delayers = rejectx(neighbors).reject { |x| !x.tags.include?("EN1x: Delayer") || x.tags.include?("EN2: Connected") }

    uninterest = neighbors.reject { |x| !x.tags.include?("X: Uninterested") }
    no_email = neighbors.reject { |x| !x.tags.include?("EN1x: No Email") }
    c_neighbors = uninterest | no_email

    tlaunch = conn.reject { |x| !x.tags.include?("EN2: Connected") }
    tremind = neighbors.reject { |x| !x.tags.include?("Email: Excited Neighbor Non-Responder 1: Reminder") }

    l_conn = rejectx(tlaunch).reject { |x| x.tags.include?("Type: Excited Neighbor Partner") }
    remind = tlaunch & tremind
    launch = tlaunch - remind

    neighbor_p = neighbors.reject { |x| !x.tags.include?("Type: Excited Neighbor Partner") }

    n_count = neighbors.count
    p_conn = p_conn.count
    no_resp = no_resp.count
    delayers = delayers.count
    l_conn = l_conn.count
    launch = launch.count
    remind = remind.count
    neighbor_p = neighbor_p.count

    a = percent(p_conn, n_count)
    b = percent(c_leaders, n_count)
    c = percent(l_conn, n_count)
    d = percent(launch, conn.count)
    e = percent(remind, tlaunch.count)
    f = percent(neighbor_p, n_count)

    r_neighbors << ["Potential Excited Neighbor", n_count, "*Insert witty text here*"]
    r_neighbors << ["Possible Connections", p_conn, a.to_s + "%"]
    r_neighbors << ["==> Non-Responders", no_resp, ""]
    r_neighbors << ["==> Delayers", delayers, ""]
    r_neighbors << ["Closed Neighbors", c_leaders, b.to_s + "%"]
    r_neighbors << ["==> Uninterested", uninterest.count, ""]
    r_neighbors << ["==> Dead Email", no_email.count, ""]
    r_neighbors << ["Live Connections", l_conn, c.to_s + "%"]
    r_neighbors << ["==> Launch Email", launch, d.to_s + "%"]
    r_neighbors << ["==> Reminder Email", remind, e.to_s + "%"]
    r_neighbors << ["Excited Neighbor Partners", neighbor_p, f.to_s + "%"]

    # Activating Excited Neighbors
    a_neighbors = []
    a_neighbors << headers

    conn = neighbors.reject { |x| !x.tags.include?("EN2: Connected") }
    scheduled = conn.reject { |x| !x.tags.include?("EN3: Call Scheduled") }
    held = scheduled.reject { |x| !x.tags.include?("EN4: Call Held") }
    n_partners = neighbors.reject { |x| !x.tags.include?("Type: Excited Neighbor Partner") }

    cards = neighbors.reject { |x| !x.tags.include?("Status: Cards Sent") }
    blurbs = neighbors.reject { |x| !x.tags.include?("Status: Blurb Sent") }
    focp = neighbors.reject { |x| !x.tags.include?("Status: Friend of OurCommonPlace") }

    conn = conn.count
    scheduled = scheduled.count
    held = held.count
    n_partners = n_partners.count
    cards = cards.count
    blurbs = blurbs.count
    focp = focp.count

    a = percent(scheduled, conn)
    b = percent(held, conn)
    c = percent(n_partners, conn)

    a_neighbors << ["Connected Excited Neighbors", conn, "1.0"]
    a_neighbors << ["Call Scheduled", scheduled, a.to_s + "%"]
    a_neighbors << ["Call Held", held, b.to_s + "%"]
    a_neighbors << ["Excited Neighbor Partners", n_partners, c.to_s + "%"]
    a_neighbors << ["Cards Sent", cards]
    a_neighbors << ["Blurbs Sent", blurbs]
    a_neighbors << ["Friends of CommonPlace", focp]

    # Early Adopters Metrics
    adopters = residents.reject { |x| !x.tags.include?("Status: Joined CP") || x.tags.include?("Type: Excited Neighbor") || x.tags.include?("Type: Leader") }

    # Recruiting Early Adopters
    r_adopters = []
    r_adopters << headers

    conn = adopters.reject { |x| !x.tags.include?("EA1: Contacted") }
    p_conn = rejectx(conn).reject { |x| x.tags.include?("EA1x: No Email") || x.tags.include?("EA2: Connected") }
    no_resp = rejectx(p_conn).reject { |x| x.tags.include?("EA1x: Delayer") }
    delayers = rejectx(adopters).reject { |x| !x.tags.include?("EA1x: Delayer") || x.tags.include?("EA2: Connected") }

    uninterest = adopters.reject { |x| !x.tags.include?("X: Uninterested") }
    no_email = adopters.reject { |x| !x.tags.include?("EA1x: No Email") }
    c_neighbors = uninterest | no_email

    tlaunch = conn.reject { |x| !x.tags.include?("EA2: Connected") }
    task = adopters.reject { |x| !x.tags.include?("Email: Early Adopter Non-Responder 1: Asks") }

    l_conn = rejectx(tlaunch).reject { |x| x.tags.include?("Type: Early Adopter Partner") }
    ask = tlaunch & task
    launch = tlaunch - ask

    adopter_p = adopters.reject { |x| !x.tags.include?("Type: Early Adopter Partner") }

    a_count = neighbors.count
    p_conn = p_conn.count
    no_resp = no_resp.count
    delayers = delayers.count
    l_conn = l_conn.count
    launch = launch.count
    ask = ask.count
    adopter_p = adopter_p.count

    a = percent(p_conn, a_count)
    b = percent(c_leaders, a_count)
    c = percent(l_conn, a_count)
    d = percent(launch, conn.count)
    e = percent(ask, task.count)
    f = percent(adopter_p, a_count)

    r_adopters << ["Potential Early Adopters", a_count, "You can't handle the truth!"]
    r_adopters << ["Possible Connections", p_conn, a.to_s + "%"]
    r_adopters << ["==> Non-Responders", no_resp, ""]
    r_adopters << ["==> Delayers", delayers, ""]
    r_adopters << ["Closed Neighbors", c_leaders, b.to_s + "%"]
    r_adopters << ["==> Uninterested", uninterest.count, ""]
    r_adopters << ["==> Dead Email", no_email.count, ""]
    r_adopters << ["Live Connections", l_conn, c.to_s + "%"]
    r_adopters << ["==> Launch Email", launch, d.to_s + "%"]
    r_adopters << ["==> Asks Email", ask, e.to_s + "%"]
    r_adopters << ["Early Adopter Partners", adopter_p, f.to_s + "%"]

    # Activating Early Adopters
    a_adopters = []
    a_adopters << headers

    conn = adopters.reject { |x| !x.tags.include?("EA2: Connected") }
    scheduled = conn.reject { |x| !x.tags.include?("EA3: Call Scheduled") }
    held = scheduled.reject { |x| !x.tags.include?("EA4: Call Held") }
    a_partners = adopters.reject { |x| !x.tags.include?("Type: Early Adopter Partner") }

    cards = adopters.reject { |x| !x.tags.include?("Status: Cards Sent") }
    blurbs = adopters.reject { |x| !x.tags.include?("Status: Blurb Sent") }
    focp = adopters.reject { |x| !x.tags.include?("Status: Friend of OurCommonPlace") }

    conn = conn.count
    scheduled = scheduled.count
    held = held.count
    a_partners = a_partners.count
    cards = cards.count
    blurbs = blurbs.count
    focp = focp.count

    a = percent(scheduled, conn)
    b = percent(held, conn)
    c = percent(n_partners, conn)

    a_adopters << ["Connected Early Adopters", conn, "Perfect"]
    a_adopters << ["Call Scheduled", scheduled, a.to_s + "%"]
    a_adopters << ["Call Held", held, b.to_s + "%"]
    a_adopters << ["Excited Adopter Partners", n_partners, c.to_s + "%"]
    a_adopters << ["Cards Sent", cards]
    a_adopters << ["Blurbs Sent", blurbs]
    a_adopters << ["Friends of CommonPlace", focp]

    # Flyer Metrics
    flyers = []
    flyers << ["", "Dropped", "Dropped & Joined", "Dropped & Referral Source", "D&J Conversion Rate", "D&R Conversion Rate"]

    flyer_a = residents.reject { |x| !x.tags.include?("Flyer: A") }
    flyer_b = residents.reject { |x| !x.tags.include?("Flyer: B") }
    flyer_c = residents.reject { |x| !x.tags.include?("Flyer: C") }
    flyer_d = residents.reject { |x| !x.tags.include?("Flyer: D") }

    joined_a = flyer_a.reject { |x| !x.tags.include?("Status: Joined CP") }
    joined_b = flyer_a.reject { |x| !x.tags.include?("Status: Joined CP") }
    joined_c = flyer_a.reject { |x| !x.tags.include?("Status: Joined CP") }
    joined_d = flyer_a.reject { |x| !x.tags.include?("Status: Joined CP") }

    mail_a = flyer_a.reject { |x| !x.tags.include?("Referral: Flyer in the mail") }
    mail_b = flyer_a.reject { |x| !x.tags.include?("Referral: Flyer in the mail") }
    mail_c = flyer_a.reject { |x| !x.tags.include?("Referral: Flyer in the mail") }
    mail_d = flyer_a.reject { |x| !x.tags.include?("Referral: Flyer in the mail") }

    flyer_a = flyer_a.count
    flyer_b = flyer_b.count
    flyer_c = flyer_c.count
    flyer_d = flyer_d.count
    joined_a = joined_a.count
    joined_b = joined_b.count
    joined_c = joined_c.count
    joined_d = joined_d.count
    mail_a = mail_a.count
    mail_b = mail_b.count
    mail_c = mail_c.count
    mail_d = mail_d.count

    a = percent(joined_a, flyer_a)
    b = percent(joined_b, flyer_b)
    c = percent(joined_c, flyer_c)
    d = percent(joined_d, flyer_d)

    aa = percent(mail_a, flyer_a)
    bb = percent(mail_b, flyer_b)
    cc = percent(mail_c, flyer_c)
    dd = percent(mail_d, flyer_d)

    flyers << ["Flyer A", flyer_a, joined_a, mail_a, a, aa]
    flyers << ["Flyer B", flyer_b, joined_b, mail_b, b, bb]
    flyers << ["Flyer C", flyer_c, joined_c, mail_c, c, cc]
    flyers << ["Flyer D", flyer_d, joined_d, mail_d, d, dd]

    # Press Metrics
    press = []
    press << ["Title", "#"]

    p_press = residents.reject { |x| !x.tags.include?("Type: Press") }.count
    press_p = residents.reject { |x| !x.tags.include?("Type: Press Partner") }.count
    list = residents.reject { |x| !x.tags.include?("Type: List") }.count
    list_p = residents.reject { |x| !x.tags.include?("Type: List Partner") }.count

    press << ["Potential Press", p_press]
    press << ["Press Partner", press_p]
    press << ["List", list]
    press << ["List Partner", list_p]

    # All the data
    charts.merge!({ r_leaders: r_leaders })
    charts.merge!({ a_leaders: a_leaders })
    charts.merge!({ r_neighbors: r_neighbors })
    charts.merge!({ a_neighbors: a_neighbors })
    charts.merge!({ r_adopters: r_adopters })
    charts.merge!({ a_adopters: a_adopters })
    charts.merge!({ flyers: flyers })
    charts.merge!({ press: press })
  end

  def user_statistics
    result = {}
    residents = self.residents.all

    leader = residents.reject { |x| x.metadata[:tags].nil? || !x.metadata[:tags].include?("L2: Connected") }.map { |x| x.id }
    leaders = Flag.where("name = ? AND resident_id in (?)", "L2: Connected", leader)

    leader_p = residents.reject { |x| x.metadata[:tags].nil? || !x.metadata[:tags].include?("Type: Leader Partner") }.map { |x| x.id }
    leaders_p = Flag.where("name = ? AND resident_id in (?)", "Type: Leader Partner", leader_p)

    neighbor = residents.reject { |x| x.metadata[:tags].nil? || !x.metadata[:tags].include?("EN2: Connected") }.map { |x| x.id }
    neighbors = Flag.where("name = ? AND resident_id in (?)", "EN2: Connected", neighbor)

    neighbor_p = residents.reject { |x| x.metadata[:tags].nil? || !x.metadata[:tags].include?("Type: Excited Neighbor Partner") }.map { |x| x.id }
    neighbors_p = Flag.where("name = ? AND resident_id in (?)", "Type: Excited Neighbor Partner", neighbor_p)

    adopter = residents.reject { |x| x.metadata[:tags].nil? || !x.metadata[:tags].include?("EA2: Connected") }.map { |x| x.id }
    adopters = Flag.where("name = ? AND resident_id in (?)", "EA2: Connected", adopter)

    adopter_p = residents.reject { |x| x.metadata[:tags].nil? || !x.metadata[:tags].include?("Type: Early Adopter Partner") }.map { |x| x.id }
    adopters_p = Flag.where("name = ? AND resident_id in (?)", "Type: Early Adopter Partner", adopter)

    users = graph(self.users.all)
    posts = graph(self.posts.all)
    events = graph(self.events.all)

    leader = graph(leaders)
    leader_p = graph(leaders_p)
    neighbor = graph(neighbors)
    neighbor_p = graph(neighbors_p)
    adopter = graph(adopters)
    adopter_p = graph(adopters_p)

    result.merge!({users: users})
    result.merge!({posts: posts})
    result.merge!({events: events})
    result.merge!({leaders: leader})
    result.merge!({leaders_p: leader_p})
    result.merge!({neighbors: neighbor})
    result.merge!({neighbors_p: neighbor_p})
    result.merge!({adopters: adopter})
    result.merge!({adopters_p: adopter_p})
  end

  def growth_percentage(format = true, start = 1.week.ago, finish = DateTime.current)
    value = (self.users.up_to(finish).count - self.users.up_to(start).count).to_f / (((self.users.up_to(start).count || 1) + (self.users.up_to(finish).count))/2).to_f
    if format
      return value * 100
    else
      return value
    end
  end

  def penetration_percentage(format = true)
    return -1 unless self.households?
    value = (self.users.count.to_f / self.households.to_f)
    if format
      return value * 100
    else
      return value
    end
  end
end
