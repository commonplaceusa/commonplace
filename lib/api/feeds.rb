class API
  class Feeds < Base

    helpers do

      # Finds the feed by params[:id] or halts with 404
      def find_feed
        @feed ||= case params[:id]
                  when /^\d+$/
                    Feed.find_by_id(params[:id])
                  else
                    Feed.find_by_slug(params[:id])
                  end
        @feed || (halt 404)
      end

    end
    
    # Updates the feed attributes
    #
    # Requires ownership
    put "/:id" do
      control_access :owner, find_feed
      
      find_feed.name = request_body["name"]
      find_feed.about = request_body["about"]
      find_feed.kind = request_body["kind"]
      find_feed.phone = request_body["phone"]
      find_feed.website = request_body["website"]
      find_feed.address = request_body["address"]
      find_feed.slug = request_body["slug"]
      find_feed.feed_url = request_body["rss"]
      
      if find_feed.save
        serialize(find_feed)
      else
        [400, "could not save"]
      end
    end

    # Creates a feed announcement
    # 
    # Requires feed ownership
    post "/:id/announcements" do
      control_access :owner, find_feed
      
      announcement = Announcement.new(:owner_type => "Feed",
                                      :owner_id => find_feed.id,
                                      :subject => request_body['title'],
                                      :body => request_body['body'],
                                      :community => current_user.community,
                                      :group_ids => request_body["groups"])
      if announcement.save
        kickoff.deliver_announcement(announcement)
        serialize(announcement)
      else
        [400, "errors"]
      end
    end

    # Gets a list of the feed's announcements
    get "/:id/announcements" do
      control_access :public
      
      scope = Announcement.where("owner_id = ? AND owner_type = ?", find_feed.id, "Feed")
      serialize(paginate(scope.includes(:replies, :owner).reorder("GREATEST(replied_at,created_at) DESC")))
    end

    # Creates a feed event
    # 
    # Requires feed ownership
    post "/:id/events" do
      control_access :owner, find_feed

      event = Event.new(:owner_type => "Feed",
                        :owner_id => find_feed.id,
                        :name => request_body['title'],
                        :description => request_body['body'],
                        :date => request_body['date'],
                        :start_time => request_body['starts_at'],
                        :end_time => request_body['ends_at'],
                        :venue => request_body['venue'],
                        :address => request_body['address'],
                        :tag_list => request_body['tags'],
                        :community => current_user.community,
                        :group_ids => request_body["groups"])
      if event.save
        serialize(event)
      else
        [400, "errors"]
      end
    end

    # Gets the feed's events
    get "/:id/events" do
      control_access :public

      scope = Event.where("owner_id = ? AND owner_type = ?",find_feed.id, "Feed")
      serialize(paginate(scope.upcoming.includes(:replies).reorder("date ASC")))
    end
    
    # Creates a feed essay
    # 
    # Requires feed ownership
    post "/:id/essays" do
      control_access :owner, find_feed

      essay = Essay.new(:feed_id => find_feed.id,
                        :user_id => current_user.id,
                        :subject => request_body["title"],
                        :body => request_body["body"])
      if essay.save
        serialize essay
      else
        [400, "errors"]
      end
    end
    
    # Gets the feed essays
    get "/:id/essays" do
      control_access :public

      serialize(paginate(find_feed.essays))
    end

    # Gets the feed subscribers
    get "/:id/subscribers" do
      control_access :public

      serialize(paginate(find_feed.subscribers))
    end

    # Send invites from the feed
    post "/:id/invites" do
      control_access :owner, find_feed

      kickoff.deliver_feed_invite(request_body['emails'], find_feed)
      [200, ""]
    end

    # Send a message to the feed
    post "/:id/messages" do
      control_access :community_member, find_feed.community
      message = Message.new(:subject => request_body['subject'],
                            :body => request_body['body'],
                            :messagable_type => "Feed",
                            :messagable_id => find_feed.id,
                            :user => current_user)
      if message.save
        [200, ""]
      else
        [400, "errors"]
      end
    end
    
    # Returns the serialized feed info
    get "/:id" do
      control_access :public
      serialize find_feed
    end

    # Gets the list of feed owners
    get "/:id/owners" do
      control_access :owner, find_feed

      if find_feed.get_feed_owner(current_user)
        serialize(find_feed.feed_owners)
      else
        [401, "unauthorized"]
      end
    end
    
    # Get the feed's swipes
    get "/:id/swipes" do
      control_access :public
      serialize(paginate(find_feed.swipes))
    end

    # Add a new feed owner
    post "/:id/owners" do
      control_access :owner, find_feed
      params["emails"].split(",").each do |email|
        user = User.find_by_email(email.gsub(" ",""))
        existing_owner = find_feed.get_feed_owner(user)
        if user and !existing_owner
          owner = FeedOwner.new(:feed => find_feed,
                                :user => user)
          owner.save
        end
      end
      [200, ""]
    end

    # Remove a feed owner
    delete "/:id/owners/:owner_id" do
      control_access :owner, find_feed

      owner = FeedOwner.find(params[:owner_id])
      owner.destroy
    end

    # Create the feed avatar
    post "/:id/avatar" do
      control_access :owner, find_feed

      find_feed.avatar = params[:avatar][:tempfile]
      find_feed.avatar.instance_write(:filename, params[:avatar][:filename])
      find_feed.save
      serialize find_feed
    end
    
    # Updates the feed avatar's cropping
    #
    # Requires authentication
    #
    # Request params
    #   crop_x - the cropping distance from the left
    #   crop_y - the cropping distance from the top
    #   crop_w - the cropping width
    #   crop_h - thi cropping height
    #
    # Returns the serialized feed
    put "/:id/crop" do
      control_access :owner, find_feed

      find_feed.crop_x = request_body["crop_x"]
      find_feed.crop_y = request_body["crop_y"]
      find_feed.crop_w = request_body["crop_w"]
      find_feed.crop_h = request_body["crop_h"]
      find_feed.save
      serialize find_feed
    end

    # Remove the feed avatar
    delete "/:id/avatar" do
      control_access :owner, find_feed

      find_feed.avatar = nil
      find_feed.save
      serialize find_feed
    end

  end
end
