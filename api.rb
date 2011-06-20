class API < Sinatra::Base
  
  helpers do
    
    def current_account
      @_user ||= User.find_by_id(session['user_credentials_id']) 
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
    cache_control :public, :must_revalidate, :max_age => 10
    content_type :json
    authenticate!
    authorize!
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
    community = Community.find(id)
    last_modified(community.posts.unscoped.
                  order("updated_at DESC").first.updated_at)
    serialize(community.posts.includes(:user, :replies).to_a)
  end

  get "/communities/:id/events" do |id|
    community = Community.find(id)
    last_modified(community.events.order("updated_at DESC").first.updated_at)
    serialize(community.events.upcoming.includes(:replies).to_a)
  end

  get "/communities/:id/announcements" do |id|
    community = Community.find(id)
    last_modified(community.announcements.order("updated_at DESC").first.updated_at)
    serialize(community.announcements.includes(:replies).to_a)
  end

  get "/communities/:id/group_posts" do |id|
    community = Community.find(id)
     last_modified(GroupPost.includes(:group).where(:groups => {:community_id => community.id}).order("group_posts.updated_at DESC").first.updated_at)
    serialize(GroupPost.includes(:group, :user, :replies => :user).where(:groups => {:community_id => community.id}).to_a)
  end

  get "/communities/:id/feeds" do |id|
    community = Community.find(id)
    last_modified(community.feeds.order("updated_at DESC").first.updated_at)
    serialize(community.feeds.to_a)
  end

  get "/communities/:id/groups" do |id|
    community = Community.find(id) 
    last_modified(community.groups.order("updated_at DESC").first.updated_at)
    serialize(community.groups.to_a)
  end

  get "/communities/:id/users" do |id|
    community = Community.find(id)
    last_modified(community.users.order("updated_at DESC").first.updated_at)
    serialize(community.users.to_a)
  end
end
