class API
  class Posts < Unauthorized

    helpers do
    
      def auth(post)
        halt [401, "wrong community"] unless in_comm(post.community.id)
        post.user == current_account or current_account.admin
      end

    end

    put "/:id" do |id|
      post = Post.find(id)
      unless post.present?
        [404, "errors"]
      end
      post.subject  = request_body['title']
      post.body     = request_body['body']
      post.category = request_body["category"]

      if auth(post) and post.save
        serialize(post)
      elsif !auth(post)
        [401, "errors: #{current_account} does not have access."]
      else
        [400, "errors: #{post.errors.full_messages.to_s}"]
      end
    end

    delete "/:id" do |id|
      post = Post.find(id)
      unless post.present?
        [404, "errors"]
      end

      if auth(post)
        post.destroy
      else
        [404, "errors"]
      end
    end

    get "/:id" do |id|
      post = Post.find(id)
      halt [401, "wrong community"] unless in_comm(post.community.id)
      serialize post
    end

    post "/:id/thank" do |id|
      thank(Post, id)
    end

    post "/:id/replies" do |id|
      post = Post.find(id)
      halt [401, "wrong community"] unless in_comm(post.community.id)
      reply = Reply.new(:repliable => post,
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
