class API < Sinatra::Base
  
  helpers do
    
    def current_account
      @_user ||= User.find_by_id(session['user_credentials_id']) 
    end

    def authenticate!
      current_account || halt(401)
    end

    def request_body
      JSON.parse(request.body.read.to_s)
    end

  end

  before { content_type :json }


  [Post, GroupPost, Announcement, Event].each do |repliable_class|
    
    post "/#{repliable_class.name.pluralize.underscore}/:id/replies" do |id|
      reply = Reply.create!(:repliable => repliable_class.find(id),
                            :user => current_account,
                            :body => request_body['body'])
      Serializer::serialize(reply).to_json
    end

  end
  
end
