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

  end

  before do 
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
      reply = Reply.create!(:repliable => repliable_class.find(id),
                            :user => current_account,
                            :body => request_body['body'])
      Serializer::serialize(reply).to_json
    end

  end

  # POST /communities/:id/posts
  # { title: String 
  # , body: Text
  # , style: one_of('publicity', 'event', nil)
  # , feed: Integer 
  # , groups: [Integer] 
  # , occurs: Date
  # , starts: Time
  # , ends: Time
  # , venue: String
  # , address: String
  # , tags: String }
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

  

end
