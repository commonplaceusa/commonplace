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
    
    post "/posts/#{repliable_class.name.pluralize.underscore}/:id/replies" do |id|
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
    post = if request_body.key?('groups')
             GroupPost.new(:user => current_account,
                           :subject => request_body['title'],
                           :body => request_body['body'],
                           :group => Group.find(request_body['groups'].first))
           elsif request_body['style'] == "event"
             Event.new(:owner => request_body['feed'] ? Feed.find(request_body['feed']) : current_account,
                       :description => request_body['body'],
                       :name => request_body['title'],
                       :date => request_body['occurs'],
                       :start_time => request_body['start_time'],
                       :end_time => request_body['end_time'],
                       :venue => request_body['venue'],
                       :address => request_body['address'],
                       :tags => request_body['tags'],
                       :community_id => community_id)
           elsif request_body['style'] == 'publicity'
             Announcement.new(:owner => request_body['feed'] ? Feed.find(request_body['feed']) : current_account,
                              :subject => request_body['title'],
                              :body => request_body['body'],
                              :community_id => community_id)
           else 
             Post.new(:user => current_account,
                      :community_id => community_id,
                      :subject => request_body['title'],
                      :body => request_body['body'])
           end
    if post.save
      serialize(post)
    else
      [400, "errors"]
    end
  end

end
