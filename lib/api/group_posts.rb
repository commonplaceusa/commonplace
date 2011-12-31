class API
  class GroupPosts < Base

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
      post = GroupPost.find(id)
      halt [401, "wrong community"] unless in_comm(post.community.id)
      thank = Thank.new(:user_id => current_account.id,
                         :thankable_id => id,
                         :thankable_type => "GroupPost")
      if thank.save
        kickoff.deliver_thank_notification(thank)
      else
        [400, "errors"]
      end
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
    
    get "/:id/thanks" do |id|
		group_post = GroupPost.find(id)
		halt [401, "wrong community"] unless in_comm(group_post.community.id)
		halt [400, "errors: already thanked"] unless group_post.thanks.index {|t| t.user == current_account } == nil
		thank = Thank.new(:thankable => group_post,
						:user => current_account)
		if thank.save
		  serialize(group_post)
		else
		  [400, "errors: #{post.errors.full_messages.to_s}"]
		end
	end


  end
end
