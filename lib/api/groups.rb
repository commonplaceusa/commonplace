class API
  class Groups < Base

    get "/:id" do |id|
      serialize(Group.find(id))
    end
    
    post "/:id/posts" do |id|
      group_post = GroupPost.new(:group => Group.find(id),
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

    get "/:id/posts" do |id|
      scope = Group.find(id).group_posts.reorder("updated_at DESC")
      serialize( paginate(scope) )
    end

    get "/:id/members" do |id|
      scope = Group.find(id).subscribers
      serialize( paginate(scope) )
    end

    get "/:id/events" do |id|
      scope = Group.find(id).events.upcoming.reorder("date ASC")
      serialize( paginate(scope) )
    end

    get "/:id/announcements" do |id|
      scope = Group.find(id).announcements.reorder("updated_at DESC")
      serialize( paginate(scope) )
    end

  end
end
