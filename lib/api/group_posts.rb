class API
  class GroupPosts < Unauthorized

    helpers do
    
      def auth(post)
        halt [401, "wrong community"] unless in_comm(post.group.community.id)
        post.user == current_account or current_account.admin
      end

    end

    put "/:id" do |id|
      post = GroupPost.find(id)
      unless post.present?
        [404, 'errors']
      end

      post.subject = request_body['title']
      post.body = request_body['body']

      if auth(post) and post.save
        serialize(post)
      else
        unless auth(post)
          [401, 'unauthorized']
        else
          [500, 'could not save']
        end
      end
    end

    delete "/:id" do |id|
      post = GroupPost.find(id)
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
      post = GroupPost.find(id)
      halt [401, "wrong community"] unless in_comm(post.group.community.id)
      serialize post
    end

    post "/:id/thank" do |id|
      thank(GroupPost, id)
    end

    post "/:id/replies" do |id|
      post = GroupPost.find(id)
      halt [401, "wrong community"] unless in_comm(post.group.community.id)
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
