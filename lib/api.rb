class API < Sinatra::Base

  helpers do
    
    def current_account
      @_user ||= if request.env["HTTP_AUTHORIZATION"].present?
                   User.find_by_authentication_token(request.env["HTTP_AUTHORIZATION"])
                 elsif params['authentication_token'].present?
                   User.find_by_authentication_token(params[:authentication_token])
                 else
                   User.find_by_authentication_token(request.cookies['authentication_token'])
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

    def page
      (params[:page] || 0).to_i
    end

    def limit
      (params[:limit] || 25).to_i
    end

    def paginate(scope)
      scope.limit(limit).offset(limit * page)
    end

    def kickoff
      request.env["kickoff"] ||= KickOff.new
    end

    def last_modified_by_updated_at(scope)
    last_modified(scope.unscoped
                    .reorder("updated_at DESC")
                    .select('updated_at')
                    .first.try(&:updated_at))
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
  ["Post", "GroupPost", "Announcement", "Event", "Message"].each do |class_name|
    
    post "/#{class_name.pluralize.underscore}/:id/replies" do |id|
      repliable_class = class_name.constantize
      reply = Reply.new(:repliable => repliable_class.find(id),
                        :user => current_account,
                        :body => request_body['body'])

      if reply.save
        kickoff.deliver_reply(reply)
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
      kickoff.deliver_post(post)
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

    if (announcement.user == current_account or current_account.admin) and announcement.save
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
    if (event.user == current_account or current_account.admin) and event.save
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

  # POST /communities/:id/events
  # { title: String
  # , about: String
  # , date: DateString
  # , start: TimeString
  # , end: TimeString
  # , venue: String
  # , address: String
  # , tags: String
  # , feed: Integer
  # , groups: [Integer] }
  #
  post "/communities/:id/events" do
    event = Event.new(:owner => request_body['feed'].present? ? Feed.find(request_body['feed']) : current_account,
                      :name => request_body['title'],
                      :description => request_body['about'],
                      :date => request_body['date'],
                      :start_time => request_body['start'],
                      :end_time => request_body['end'],
                      :venue => request_body['venue'],
                      :address => request_body['address'],
                      :tag_list => request_body['tags'],
                      :community => current_account.community,
                      :group_ids => request_body['groups']
                      )
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
      kickoff.deliver_announcement(announcement)
      serialize(announcement)
    else
      [400, "errors"]
    end
  end

  # POST /communities/:id/announcements
  # { title: String
  # , body: String
  # , feed: Integer 
  # , groups: [Integer] }
  post "/communities/:id/announcements" do
    announcement = Announcement.new(:owner => request_body['feed'].present? ? Feed.find(request_body['feed']) : current_account,
                                    :subject => request_body['title'],
                                    :body => request_body['body'],
                                    :community_id => params[:id],
                                    :group_ids => request_body["groups"])

    if announcement.save
      kickoff.deliver_announcement(announcement)
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
                                    :community => current_account.community,
                                    :group_ids => request_body["groups"])
    if announcement.save
      kickoff.deliver_announcement(announcement)
      serialize(announcement)
    else
      [400, "errors"]
    end
  end

  get "/feeds/:id/announcements" do |feed_id|
    scope = Announcement.where("owner_id = ? AND owner_type = ?", feed_id, "Feed")
    serialize(paginate(scope.includes(:replies, :owner).reorder("updated_at DESC")))
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
                      :name => request_body['title'],
                      :description => request_body['about'],
                      :date => request_body['date'],
                      :start_time => request_body['start'],
                      :end_time => request_body['end'],
                      :venue => request_body['venue'],
                      :address => request_body['address'],
                      :tag_list => request_body['tags'],
                      :community => current_account.community,
                      :group_ids => request_body["groups"])
    if event.save
      serialize(event)
    else
      [400, "errors"]
    end
  end

  get "/feeds/:id/events" do |feed_id|
    scope = Event.where("owner_id = ? AND owner_type = ?",feed_id, "Feed")
    serialize(paginate(scope.upcoming.includes(:replies).reorder("date ASC")))
  end

  get "/feeds/:id/subscribers" do |feed_id|
    serialize(paginate(Feed.find(feed_id).subscribers))
  end

  # POST "/feeds/:id/invites"
  # { emails: [String]
  # , message: String }
  #
  post "/feeds/:id/invites" do |feed_id|
    kickoff.deliver_feed_invite(request_body['emails'], Feed.find(feed_id))
    [200, ""]
  end

  # POST "/feeds/:id/messages"
  # { subject: String
  # , body: String }
  #
  # Authorization: any account
  post "/feeds/:id/messages" do |feed_id|
    message = Message.new(:subject => request_body['subject'],
                          :body => request_body['body'],
                          :messagable_type => "Feed",
                          :messagable_id => feed_id,
                          :user => current_account)
    if message.save
      [200, ""]
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
      kickoff.deliver_group_post(group_post)
      serialize(group_post)
    else
      [400, "errors"]
    end
  end

  # POST "/communities/:id/group_posts"
  # { title: String
  # , body: String
  # , group: Integer }
  #
  post "/communities/:id/group_posts" do
    group_post = GroupPost.new(:group => Group.find(request_body['group']),
                               :subject => request_body['title'],
                               :body => request_body['body'],
                               :user => current_account)
    if group_post.save
      kickoff.deliver_group_post(group_post)
      serialize(group_post)
    else
      [400, "errors"]
    end
  end
  
  # POST /users/:id/messages
  # { subject: String
  # , body: String }
  #
  # Authorization: Account community is person community
  post "/users/:id/messages" do |id|
    message = Message.new(:subject => request_body['subject'],
                          :body => request_body['body'],
                          :messagable => User.find(id),
                          :user => current_account)
    if message.save
      kickoff.deliver_user_message(message)
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
    current_account.feeds << Feed.find(params[:id] || request_body['id'])
    serialize(Account.new(current_account))
  end

  # DELETE /subscriptions/feeds/:id
  # { }
  # Authorization: Account exists
  delete "/account/subscriptions/feeds/:id" do |id|
    current_account.feeds.delete(Feed.find(id))
    serialize(Account.new(current_account))
  end

  # POST /account/subscriptions/groups
  # { id: Integer }
  # Authorization: Account community is Feed community
  post "/account/subscriptions/groups" do 
    current_account.groups << Group.find(params[:id] || request_body['id'])
    serialize(Account.new(current_account))
  end

  # DELETE /account/subscriptions/groups/:id
  # { }
  # Authorization: Account exists
  delete "/account/subscriptions/groups/:id" do |id|
    current_account.groups.delete(Group.find(id))
    serialize(Account.new(current_account))
  end

  post "/account/mets" do
    current_account.people << User.find(params[:id] || request_body["id"])
    serialize(Account.new(current_account))
  end

  delete "/account/mets/:id" do |id|
    current_account.people.delete(User.find(id))
    serialize(Account.new(current_account))
  end
  
  get "/account/inbox" do 
    serialize(paginate(current_account.inbox.reorder("updated_at DESC")))
  end

  get "/account/inbox/sent" do
    serialize(paginate(current_account.sent_messages.reorder("updated_at DESC")))
  end

  get "/communities/:id/posts" do |id|
    last_modified_by_updated_at(Post)

    serialize(paginate(Community.find(id).posts.includes(:user, :replies)))
  end


  get "/communities/:id/events" do |id|
    last_modified([Event.unscoped.reorder("updated_at DESC").
                   select('updated_at').
                   first.try(&:updated_at),
                   Date.today.beginning_of_day].compact.max)

    serialize(paginate(Community.find(id).events.upcoming.
                       includes(:replies).reorder("date ASC")))
  end

  get "/communities/:id/announcements" do |id|
    last_modified_by_updated_at(Announcement)

    serialize(paginate(Community.find(id).announcements.
                       includes(:replies, :owner).
                       reorder("updated_at DESC")))
  end

  get "/communities/:id/group_posts" do |id|
    last_modified_by_updated_at(GroupPost)

    serialize(paginate(GroupPost.order("group_posts.updated_at DESC").
                       includes(:group, :user, :replies => :user).
                       where(:groups => {:community_id => id})))
  end

  get "/communities/:id/feeds" do |id|
    last_modified_by_updated_at(Feed)

    serialize(paginate(Community.find(id).feeds))
  end

  get "/communities/:id/groups" do |id|
    last_modified_by_updated_at(Group)

    serialize(paginate(Community.find(id).groups))
  end

  get "/communities/:id/users" do |id|
    last_modified_by_updated_at(User)

     serialize(paginate(Community.find(id).users.includes(:feeds, :groups)))
  end



  post "/communities/:id/add_data_point" do |id|
    num = params[:number]
    zip_code = User.find(current_account.id).community.zip_code
    if num.include? "-"
      odds = false
      evens = false
      all = true
      if num.include? "O"
        odds = true
        all = false
        num = num.gsub("O", "")
      elsif num.include? "E"
        evens = true
        all = false
        num = num.gsub("E", "")
      end

      range = num.split("-")
      (range[0].to_i..range[1].to_i).each do |n|
        if (odds and (n % 2 == 1)) or (evens and (n % 2 == 0)) or all
          data_point = OrganizerDataPoint.new
          data_point.organizer_id = current_account.id
          data_point.address = "#{n} #{params[:address]} #{zip_code}"
          data_point.status = params[:status]
          data_point.save
        end
      end
      else
        data_point = OrganizerDataPoint.new
        data_point.organizer_id = current_account.id
        data_point.address = "#{num} #{params[:address]} #{zip_code}"
        data_point.status = params[:status]
        data_point.save
        data_point.generate_point
      end
    [200, "OK"]
  end

  get "/communities/:id/registration_points" do |id|
    headers 'Access-Control-Allow-Origin' => '*'
    community = Community.find(id)

    serialize(community.users.map &:generate_point)
  end

  get "/communities/:id/data_points" do |id|
    headers 'Access-Control-Allow-Origin' => '*'
    community = Community.find(id)
    if params[:top]
      serialize(community.organizers.map(&:organizer_data_points).flatten.uniq { |p| p.address }.select { |p| p.present? })
    end
    serialize(community.organizers.map(&:organizer_data_points).flatten.select { |p| p.present? })
  end

  get "/neighborhoods/:id/posts" do |id|
    posts = Post.includes(:user).where(:users => {:neighborhood_id => id})

    serialize(paginate(posts.includes(:user, :replies)))
  end

  get "/users/:id" do |id|
    serialize User.find(id)
  end
  
  get "/posts/:id" do |id|
    serialize Post.find(id)
  end

  get "/events/:id" do |id|
    serialize Event.find(id)
  end

  get "/announcements/:id" do |id|
    serialize Announcement.find(id)
  end

  get "/group_posts/:id" do |id|
    serialize GroupPost.find(id)
  end

  get "/groups/:id" do |id|
    serialize(id =~ /[^\d]/ ? Group.find_by_slug(id) : Group.find(id))
  end

  post "/groups/:id/posts" do |id|
    group_post = GroupPost.new(:group => Group.find(id),
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

  get "/groups/:id/posts" do |id|
    scope = Group.find(id).group_posts.reorder("updated_at DESC")
    serialize( paginate(scope) )
  end

  get "/groups/:id/members" do |id|
    scope = Group.find(id).subscribers
    serialize( paginate(scope) )
  end

  get "/groups/:id/events" do |id|
    scope = Group.find(id).events.upcoming.reorder("date ASC")
    serialize( paginate(scope) )
  end

  get "/groups/:id/announcements" do |id|
    scope = Group.find(id).announcements.reorder("updated_at DESC")
    serialize( paginate(scope) )
  end

  get "/feeds/:id" do |id|
    serialize(id =~ /[^\d]/ ? Feed.find_by_slug(id) : Feed.find(id))
  end
end
