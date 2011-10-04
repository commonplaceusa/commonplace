class API
  class Posts < Base
    put "/:id" do |id|
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

    delete "/:id" do |id|
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

    get "/:id" do |id|
      serialize Post.find(id)
    end

    post "/:id/replies" do |id|
      reply = Reply.new(:repliable => Post.find(id),
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
