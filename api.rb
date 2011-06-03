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

end
