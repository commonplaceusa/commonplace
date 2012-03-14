class API
  class Postlikes < Unauthorized
    
    before do
      if !is_method("get")
        authorize!
      end
    end

    put "/:id" do |id|
      postlike = klass.find(id)
      unless postlike.present?
        [404, "errors"]
      end
      
      set_attributes(postlike, request_body)

      if auth(postlike) and post.save
        serialize postlike
      elsif !auth(postlike)
        [401, "errors: #{current_account} does not have access."]
      else
        [400, "errors: #{postlike.errors.full_messages.to_s}"]
      end
    end

    delete "/:id" do |id|
      postlike = klass.find(id)
      unless postlike.present?
        [404, "errors"]
      end

      if auth(postlike)
        postlike.destroy
      else
        [404, "errors"]
      end
    end

    get "/:id" do |id|
      postlike = klass.find(id)
      serialize postlike
    end

    post "/:id/thank" do |id|
      thank(klass, id)
    end

    post "/:id/replies" do |id|
      postlike = klass.find(id)
      reply = Reply.new(:repliable => postlike,
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
end
