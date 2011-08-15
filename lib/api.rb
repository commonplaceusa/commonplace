class API < Sinatra::Base


# we're in development, force preloading of models
if Rails.env.development? 
  Dir.glob(Rails.root.join("app","models","*.rb")).each do |f|
    require(f)
  end
end

  
  helpers do
    
    def current_account
      @_user ||= if request.env["HTTP_AUTHORIZATION"]
                   User.find_by_single_access_token(request.env["HTTP_AUTHORIZATION"])
                 else
                   User.find_by_id(session['user_credentials_id'])
                 end
    end

    def authenticate!
      current_account || halt(401)
    end

    def request_body
      @_request_body ||= JSON.parse(request.body.read.to_s)
    end

    def authorize!
      
    end

    def serialize(thing)
      Serializer::serialize(thing).to_json
    end

    def logger
      @logger ||= Logger.new(Rails.root.join("log", "api.log"))
    end

  end

  before do 
    cache_control :public, :must_revalidate, :max_age => 0
    content_type :json
    authenticate!
    authorize!
  end

  # GET /
  # "HI!"
  get "/" do
    "HI!"
  end

  # POST /posts/:id/replies
  # { body: Text }
  # 
  # Authorization: User is in community
  [Post, GroupPost, Announcement, Event].each do |repliable_class|
    
    post "/#{repliable_class.name.pluralize.underscore}/:id/replies" do |id|
      reply = Reply.new(:repliable => repliable_class.find(id),
                        :user => current_account,
                        :body => request_body['body'])

      if reply.save
        (reply.repliable.replies.map(&:user) + [reply.repliable.user]).uniq.each do |user|
          if user != reply.user
            logger.info("Enqueue ReplyNotification #{reply.id} #{user.id}")
            Resque.enqueue(ReplyNotification, reply.id, user.id)
          end
        end
        Serializer::serialize(reply).to_json
      else
        [400, "errors"]
      end
    end
  end

  # POST /communities/:id/posts
  # { title: String 
  # , body: Text }
  #
  # Authorization: User is in community
  post "/communities/:id/posts" do |community_id|
    post = Post.new(:user => current_account,
                    :community_id => community_id,
                    :subject => request_body['title'],
                    :body => request_body['body'])
    if post.save
      current_account.neighborhood.users.receives_posts_live.each do |user|
        Resque.enqueue(PostNotification, post.id, user.id) if post.user != user
      end
      serialize(post)
    else
      [400, "errors"]
    end
  end

  # PUT /post/:id
  # { title: String
  #   body: Text }
  #
  # Authorization: User owns the Post
  put "/posts/:id" do |id|
    post = Post.find(id)
    unless post.present?
      [404, "errors"]
    end
    post.subject = request_body['title']
    post.body    = request_body['body']

    if (post.user == current_account or current_account.admin) and post.save
      serialize(post)
    elsif post.user != current_account and !current_account.admin
      if current_account.admin
        [501, "THIS SHOULD NEVER HAPPEN"]
      elsif post.user == current_account
        [502, "Should be able to edit our own posts..."]
      else
        [401, "errors: #{current_account} does not have access."]
      end
    else
      [400, "errors: #{post.errors.full_messages.to_s}"]
    end
  end

  put "/announcements/:id" do |id|
    announcement = Announcement.find(id)
    unless announcement.present?
      [404, "errors"]
    end

    announcement.subject = request_body['title']
    announcement.body = request_body['body']

    if (announcement.owner == current_account or current_account.admin) and announcement.save
      serialize(announcement)
    else
      unless (announcement.owner == current_account or current_account.admin)
        [401, 'unauthorized']
      else
        [500, 'could not save']
      end
    end
  end

  put "/events/:id" do |id|
    event = Event.find(id)
    unless event.present?
      [404, "errors"]
    end

    event.name = request_body['title']
    event.description = request_body['body']
    event.date = request_body['occurs_on']
    event.start_time = request_body['starts_at']
    event.end_time = request_body['ends_at']
    event.venue = request_body['venue']
    event.address = request_body['address']
    event.tag_list = request_body['tags']

    # TODO: This should deal with feeds...
    if (event.owner == current_account or current_account.admin) and event.save
      serialize(event)
    else
      unless (event.owner == current_account or current_account.admin)
        [401, "unauthorized"]
      else
        [500, "could not save"]
      end
    end
  end

  put "/group_posts/:id" do |id|
    post = GroupPost.find(id)
    unless post.present?
      [404, 'errors']
    end

    post.subject = request_body['title']
    post.body = request_body['body']

    if (post.user == current_account or current_account.admin) and post.save
      serialize(post)
    else
      unless (post.user == current_account or current_account.admin)
        [401, 'unauthorized']
      else
        [500, 'could not save']
      end
    end
  end

  # DELETE /posts/:id
  #
  # Authorization: User owns the Post
  delete "/posts/:id" do |id|
    post = Post.find(id)
    unless post.present?
      [404, "errors"]
    end

    if (post.user == current_account or current_account.admin)
      post.destroy
    else
      [404, "errors"]
    end
  end

  # DELETE /events/:id
  #
  # Authorization: User owns the Post
  delete "/events/:id" do |id|
    event = Event.find(id)
    unless event.present?
      [404, "errors"]
    end

    if (event.owner == current_account or current_account.admin)
      event.destroy
    else
      [404, "errors"]
    end
  end

  # DELETE /events/:id
  #
  # Authorization: User owns the Post
  delete "/announcements/:id" do |id|
    announcement = Announcement.find(id)
    unless announcement.present?
      [404, "errors"]
    end

    if (announcement.owner == current_account or current_account.admin)
      announcement.destroy
    else
      [404, "errors"]
    end
  end

  # DELETE /events/:id
  #
  # Authorization: User owns the Post
  delete "/group_posts/:id" do |id|
    post = GroupPost.find(id)
    unless event.present?
      [404, "errors"]
    end

    if (post.user == current_account or current_account.admin)
      post.destroy
    else
      [404, "errors"]
    end
  end



  # POST /events
  # { title: String
  # , about: String
  # , date: DateString
  # , start: TimeString
  # , end: TimeString
  # , venue: String
  # , address: String
  # , tags: String
  # , feed: Integer }
  #
  post "/events" do
    event = Event.new(:owner => request_body['feed'].present? ? Feed.find(request_body['feed']) : current_account,
                      :name => request_body['title'],
                      :description => request_body['about'],
                      :date => request_body['date'],
                      :start_time => request_body['start'],
                      :end_time => request_body['end'],
                      :venue => request_body['venue'],
                      :address => request_body['address'],
                      :tag_list => request_body['tags'],
                      :community => current_account.community)
    if event.save
      serialize(event)
    else
      [400, "errors"]
    end
  end

  # POST /announcements
  # { title: String
  # , body: String
  # , feed: Integer }
  #
  post "/announcements" do
    announcement = Announcement.new(:owner => request_body['feed'].present? ? Feed.find(request_body['feed']) : current_account,
                                    :subject => request_body['title'],
                                    :body => request_body['body'],
                                    :community => current_account.community)

    if announcement.save
      if announcement.owner.is_a?(Feed)
        announcement.owner.live_subscribers.each do |user|
          Resque.enqueue(AnnouncementNotification, announcement.id, user.id)
        end
      end
      serialize(announcement)
    else
      [400, "errors"]
    end
  end

  # POST /feeds/:id/announcements
  # { title: String
  # , body: String }
  #
  # Authorization: account owns feed
  post "/feeds/:id/announcements" do |feed_id|
    announcement = Announcement.new(:owner_type => "Feed",
                                    :owner_id => feed_id,
                                    :subject => request_body['title'],
                                    :body => request_body['body'],
                                    :community => current_account.community)
    if announcement.save
      announcement.owner.live_subscribers.each do |user|
        Resque.enqueue(AnnouncementNotification, announcement.id, user.id)
      end
      serialize(announcement)
    else
      [400, "errors"]
    end
  end

  # POST /feeds/:id/events
  # { title: String
  # , about: String
  # , date: DateString
  # , start: TimeString
  # , end: TimeString
  # , venue: String
  # , address: String
  # , tags: String }
  #
  post "/feeds/:id/events" do |feed_id|
    event = Event.new(:owner_type => "Feed",
                      :owner_id => feed_id,
                      :name => request_body['title']
                      :description => request_body['about'],
                      :date => request_body['date'],
                      :start_time => request_body['start'],
                      :end_time => request_body['end'],
                      :venue => request_body['venue'],
                      :address => request_body['address'],
                      :tag_list => request_body['tags'],
                      :community => current_account.community)
    if event.save
      serialize(event)
    else
      [400, "errors"]
    end
  end
  
  # POST "/group_posts"
  # { title: String
  # , body: String
  # , group: Integer }
  #
  post "/group_posts" do
    group_post = GroupPost.new(:group => Group.find(request_body['group']),
                               :subject => request_body['title'],
                               :body => request_body['body'],
                               :user => current_account)
    if group_post.save
      group_post.group.live_subscribers.each do |user|
        Resque.enqueue(GroupPostNotification, group_post.id, user.id)
      end
      serialize(group_post)
    else
      [400, "errors"]
    end
  end
  
  
  # POST /people/:id/messages
  # { subject: String
  # , body: String }
  #
  # Authorization: Account community is person community
  post "/people/:id/messages" do |id|
    message = Message.new(:subject => request_body['subject'],
                          :body => request_body['body'],
                          :messagable => User.find(id),
                          :user => current_account)
    if message.save
      Resque.enqueue(MessageNotification, message.id, id)
      [200, ""]
    else
      [400, "errors"]
    end
  end

  # GET /account
  # { id: Integer
  # , avatar_url: String
  # , subscribed_feeds: [Integer]
  # , subscribed_groups: [Integer]
  # , is_admin: Boolean
  # , accounts: [{name: String, uid: String}]
  # , short_name: String }
  #
  # Authorization: Account exists
  get "/account" do 
    serialize Account.new(current_account)
  end

  # POST /account/subscriptions/feeds
  # { id: Integer }
  # Authorization: Account community is Feed community
  post "/account/subscriptions/feeds" do
    current_account.feeds << Feed.find(params[:id])
    [200, ""]
  end

  # DELETE /subscriptions/feeds/:id
  # { }
  # Authorization: Account exists
  delete "/account/subscriptions/feeds/:id" do |id|
    current_account.feeds.delete(Feed.find(id))
    [200, ""]
  end

  # POST /account/subscriptions/groups
  # { id: Integer }
  # Authorization: Account community is Feed community
  post "/account/subscriptions/groups" do 
    current_account.groups << Group.find(params[:id])
    [200, ""]
  end

  # DELETE /account/subscriptions/groups/:id
  # { }
  # Authorization: Account exists
  delete "/account/subscriptions/groups/:id" do |id|
    current_account.groups.delete(Group.find(id))
    [200, ""]
  end
  
  get "/communities/:id/posts" do |id|
    params.merge!(:limit => 25, :page => 0)
    community = Community.find(id)

    last_modified(community.posts.unscoped.
                  reorder("updated_at DESC").limit(1).first.try(:updated_at))

    serialize(community.posts.
              limit(params[:limit]).
              offset(params[:limit].to_i * params[:page].to_i).
              includes(:user, :replies).to_a)
  end

  get "/neighborhoods/:id/posts" do |id|
    params.merge!(:limit => 25, :page => 0)
    posts = Post.includes(:user).where(:users => {:neighborhood_id => id})

    last_modified(posts.unscoped.
                  reorder("updated_at DESC").limit(1).first.try(:updated_at))

    serialize(posts.
              limit(params[:limit]).
              offset(params[:limit].to_i * params[:page].to_i).
              includes(:user, :replies).to_a)
  end

  get "/communities/:id/events" do |id|
    params.merge!(:limit => 25, :page => 0)
    scope = Event.where("community_id = ?",id)
    last_modified([scope.reorder("updated_at DESC").limit(1).first.try(:updated_at),
                   DateTime.now.beginning_of_day.utc.to_time].compact.max)
    serialize(scope.upcoming.
                limit(params[:limit]).
                offset(params[:limit].to_i * params[:page].to_i).
                includes(:replies).to_a)
  end

  get "/communities/:id/announcements" do |id|
    params.merge!(:limit => 25, :page => 0)
    scope = Announcement.where("community_id = ?", id)
    last_modified(scope.reorder("updated_at DESC").limit(1).first.try(:updated_at))
    serialize(scope.includes(:replies, :owner).
                limit(params[:limit]).
                reorder("updated_at DESC").
                offset(params[:limit].to_i * params[:page].to_i).to_a)
  end

  get "/communities/:id/group_posts" do |id|
    params.merge!(:limit => 25, :page => 0)
    community = Community.find(id)
    last_modified(GroupPost.includes(:group).where(:groups => {:community_id => community.id}).reorder("group_posts.updated_at DESC").first.try(:updated_at))
    serialize(GroupPost.includes(:group, :user, :replies => :user).
                where(:groups => {:community_id => community.id}).
                limit(params[:limit]).
                offset(params[:limit].to_i * params[:page].to_i).
                to_a)
  end

  get "/communities/:id/feeds" do |id|
    scope = Community.find(id).feeds
    last_modified(scope.reorder("updated_at DESC").first.try(:updated_at))
    serialize(scope.to_a)
  end

  get "/communities/:id/groups" do |id|
    community = Community.find(id) 
    scope = Community.find(id).groups
    last_modified(scope.reorder("updated_at DESC").first.try(:updated_at))
    serialize(community.groups.to_a)
  end

  get "/communities/:id/users" do |id|
    scope = Community.find(id).users
    last_modified(scope.reorder("updated_at DESC").first.try(:updated_at))
    serialize(scope.includes(:feeds, :groups).to_a)
  end

  get "/users/:id" do |id|
    serialize User.find(id)
  end
  
  get "/posts/:id" do |id|
    serialize Post.find(id)
  end

  get "/groups/:id" do |id|
    serialize Group.find(id)
  end

  get "/feeds/:id" do |id|
    serialize Feed.find(id)
  end
end
