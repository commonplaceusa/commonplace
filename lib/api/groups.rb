class API
  class Groups < Unauthorized

    before "/:group_id/*" do |group_id, stuff|
      group = Group.find(group_id)
      if !is_method("get")
        authorize!
        halt [403, "wrong community"] unless in_comm(group.community_id)
      end
    end

    get "/:group_id" do |group_id|
      serialize(Group.find(group_id))
    end
    
    post "/:group_id/posts" do |group_id|
      group_post = GroupPost.new(:group => Group.find(group_id),
                                 :subject => request_body['title'],
                                 :body => request_body['body'],
                                 :user => current_account)
      if group_post.save
        group_post.group.live_subscribers.each do |user|
          Resque.enqueue(GroupPostNotification, group_post.id, user.id)
        end
        serialize(group_post)
      else
        [400, "errors"]
      end
    end

    get "/:group_id/posts" do |group_id|
      scope = Group.find(group_id).group_posts.reorder("replied_at DESC")
      serialize( paginate(scope) )
    end

    get "/:group_id/members" do |group_id|
      scope = Group.find(group_id).subscribers
      serialize( paginate(scope) )
    end

    get "/:group_id/events" do |group_id|
      scope = Group.find(group_id).events.upcoming.reorder("date ASC")
      serialize( paginate(scope) )
    end

    get "/:group_id/announcements" do |group_id|
      scope = Group.find(group_id).announcements.reorder("replied_at DESC")
      serialize( paginate(scope) )
    end

  end
end
