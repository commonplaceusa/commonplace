class API
  class GroupPosts < Base

    put "/:id" do |id|
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

    delete "/:id" do |id|
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

    get "/:id" do |id|
      serialize GroupPost.find(id)
    end

    post "/:id/replies" do |id|
      reply = Reply.new(:repliable => GroupPost.find(id),
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
