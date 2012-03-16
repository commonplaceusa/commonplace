class API
  class Groups < Base

    helpers do 
      # Finds the group using params[:id] or halts with 404
      def find_group
        @group ||= Group.find_by_id(params[:id]) || (halt 404)
      end
    end

    # Returns the serialized group
    #
    # Requires community membership
    get "/:id" do
      control_access :community_member, find_group.community
      serialize find_group
    end
    
    # Creates a Group Post
    #
    # Requires community membership
    #
    # Kicks off a job to deliver a GroupPostNotification
    # 
    # Request params:
    #   subject -
    #   body -
    #
    # Returns the serialized post if it was saved
    # Returns 400 with if it was not
    post "/:id/posts" do
      control_access :community_member, find_group.community
      
      group_post = GroupPost.new(:group => find_group,
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

    # Returns a list of the group's posts
    #
    # Requires community membership
    get "/:id/posts" do
      control_access :community_member, find_group.community

      scope = find_group.group_posts.reorder("replied_at DESC")
      serialize( paginate(scope) )
    end

    # Returns a list of the group's members
    #
    # Requires community membership
    get "/:id/members" do
      control_access :community_member, find_group.community

      scope = find_group.subscribers
      serialize( paginate(scope) )
    end

    # Returns a list of the group's events
    #
    # Requires community membership
    get "/:id/events" do |group_id|
      control_access :community_member, find_group.community

      scope = find_group.events.upcoming.reorder("date ASC")
      serialize( paginate(scope) )
    end

    # Returns a list of the group's announcements
    #
    # Requires community membership
    get "/:id/announcements" do |group_id|
      control_access :community_member, find_group.community

      scope = find_group.announcements.reorder("replied_at DESC")
      serialize( paginate(scope) )
    end

  end
end
