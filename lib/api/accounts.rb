class API
  class Accounts < Base

    helpers do
      
      # Notes that the user just checked their inbox
      # 
      # Returns the serialized account
      def checked_inbox
        current_account.checked_inbox!
        serialize(Account.new(current_account))
      end

    end

    # Returns the serialized account
    #
    # Requires authentication
    get "/" do 
      control_access :authenticated

      serialize Account.new(current_account)
    end
    
    # Updates the account's profile
    #
    # Requires authentication
    #
    # Request params:
    #   full_name (optional)
    #   about (optional)
    #   interest_list (optional)
    #   skill_list (optional)
    #   email (optional)
    #   post_receive_method (optional)
    #   receive_weekly_digest (optional)
    #   password (optional)
    #
    # Returns the serialized account on successful save
    # Returns 500 error on validation errors
    put "/" do
      control_access :authenticated
      
      current_account.full_name = request_body["name"]
      current_account.about = request_body["about"]
      current_account.interest_list = request_body["interests"]
      current_account.skill_list = request_body["skills"]
      current_account.good_list = request_body["goods"]
      current_account.email = request_body["email"]
      current_account.post_receive_method = request_body["neighborhood_posts"]
      current_account.receive_weekly_digest = request_body["bulletin"]
      
      if current_account.save
        current_account.reset_password(request_body["password"]) if request_body["password"]
        serialize Account.new(current_account)
      else
        [500, "could not save"]
      end
    end
    
    # Deletes the current account
    #
    # Requires authentication
    # 
    # Returns 200
    delete "/" do
      control_access :authenticated

      current_account.destroy
      200
    end

    # Creates the account's avatar
    # 
    # Requires authentication
    #
    # Request params:
    #   avatar[:tempfile] - an image
    #
    # Returns the serialized account
    post "/avatar" do
      control_access :authenticated

      current_account.avatar = params[:avatar][:tempfile]
      current_account.avatar.instance_write(:filename, params[:avatar][:filename])
      current_account.save
      serialize Account.new(current_account)
    end

    # Deletes the account's avatar
    # 
    # Requires authentication
    #
    # Returns the serialized account
    delete "/avatar" do
      control_access :authenticated

      current_account.avatar = nil
      current_account.save
      serialize Account.new(current_account)
    end

    # Updates the account avatar's cropping
    #
    # Requires authentication
    #
    # Request params
    #   crop_x - the cropping distance from the left
    #   crop_y - the cropping distance from the top
    #   crop_w - the cropping width
    #   crop_h - thi cropping height
    #
    # Returns the serialized account
    put "/crop" do
      control_access :authenticated

      current_user.crop_x = request_body["crop_x"]
      current_user.crop_y = request_body["crop_y"]
      current_user.crop_w = request_body["crop_w"]
      current_user.crop_h = request_body["crop_h"]
      current_user.save
      serialize Account.new(current_user)
    end

    # Updates the account's metadata
    #
    # Requires authentication
    #
    # Request params
    #   key - The metadata to update
    #   value - The value to update with
    # 
    # Returns the serialized account
    post "/metadata" do
      control_access :authenticated

      k = request_body['key']
      current_account.metadata[k] = request_body['value']
      current_account.save
      serialize Account.new(current_account)
    end

    # Adds account feed subscriptions
    #
    # Requires authentication
    #
    # Request params:
    #   id - The feed ids to subscribe to
    # 
    # Returns 401 if any of the requested feeds are in a different community
    # Returns the serialized account
    post "/subscriptions/feeds" do
      control_access :authenticated
      
      feeds = [params[:id] || request_body["id"]].flatten.map do |feed_id|
        feed = Feed.find(feed_id)
        halt [401, "wrong community"] unless in_comm(feed.community.id)
        feed
      end
      
      feeds.each do |feed|
        current_account.feeds << feed
      end
      
      serialize(Account.new(current_account))
    end

    # Removes a subscription to a feed
    #
    # Requires authentication
    # 
    # Returns the serialized account
    delete "/subscriptions/feeds/:id" do |id|
      control_access :authenticated
      
      current_account.feeds.delete(Feed.find(id))
      serialize(Account.new(current_account))
    end
    

    # Adds account group subscriptions
    #
    # Requires authentication
    #
    # Request params:
    #   id - The group ids to subscribe to
    # 
    # Returns 401 if any of the requested groups are in a different community
    # Returns the serialized account
    post "/subscriptions/groups" do
      control_access :authenticated

      groups = [params[:id] || request_body["id"]].flatten.map do |group_id|
        group = Group.find(group_id)
        halt [401, "wrong community"] unless in_comm(group.community.id)
        group
      end
      
      groups.each do |group|
        current_account.groups << group
      end
      
      serialize(Account.new(current_account))
    end

    # Removes a subscription to a group
    #
    # Requires authentication
    # 
    # Returns the serialized account
    delete "/subscriptions/groups/:id" do |id|
      control_access :authenticated

      current_account.groups.delete(Group.find(id))
      serialize(Account.new(current_account))
    end

    # Adds a Met for the given user id
    # 
    # Requires authentication
    #
    # Request params:
    #   id - the id of the user to met
    #
    # Returns 401 if the user is not in the same community
    # Returns the serialized account
    post "/mets" do
      control_access :authenticated

      user = User.find(params[:id] || request_body["id"])
      halt [401, "wrong community"] unless in_comm(user.community.id)
      current_account.people << user
      serialize(Account.new(current_account))
    end

    # Removes a met 
    #
    # Requires authentication
    delete "/mets/:id" do |id|
      control_access :authenticated

      current_account.people.delete(User.find(id))
      serialize(Account.new(current_account))
    end
    
    # Adds residents for each of the neighbors the user names
    # 
    # Requires authentication
    #
    # Notes that the current_user is a friend of the added resident
    # 
    # Request params:
    #   neighbors - A list of neighbors like {name: "", email: ""}
    #   can_contact - Whether or not we can contact the neighbors
    #
    # Returns 200
    post "/neighbors" do
      control_access :authenticated

      request_body["neighbors"].each do |neighbor|
        first_name, last_name = neighbor["name"].split(" ", 2)
        resident = current_user.community
          .residents
          .find_or_create_by_first_name_and_last_name(first_name,last_name)

        resident.metadata[:friends] ||= []
        resident.metadata[:friends] << current_user.name
        resident.metadata[:email] ||= neighbor["email"]
        resident.metadata[:can_contact] ||= request_body["can_contact"]
        resident.save
      end
      halt 200
    end
    
    # Returns a (paginated) list of the account's swipes
    # 
    # Requires authentication
    get "/swipes" do
      control_access :authenticated
      
      serialize(paginate(current_user.swipes))
    end
    
    # Returns the account's (paginated) inbox
    # 
    # Stores that they just checked their inbox
    #
    # Requires authentication
    #
    # Returns a list of messages
    get "/inbox" do
      control_access :authenticated

      checked_inbox()
      serialize(paginate(current_account.inbox.reorder("GREATEST(replied_at, created_at) DESC")))
    end

    # Returns the account's (paginated) outbox
    #
    # Requires authentication
    #
    # Returns a list of messages
    get "/inbox/sent" do
      control_access :authenticated

      serialize(paginate(current_account.sent_messages.reorder("GREATEST(replied_at, created_at) DESC")))
    end

    # Returns the a (paginated) list of messages to feeds the account owns
    #
    # Requires authentication
    #
    # Stores that they just checked their inbox
    #
    # Returns a list of messages
    get "/inbox/feeds" do
      control_access :authenticated

      checked_inbox()
      serialize(paginate(current_account.feed_messages.reorder("GREATEST(replied_at, created_at) DESC")))
    end

    # Returns a list of 'featured' neighbors for the account
    # 
    # Requires authentication
    get "/featured" do
      control_access :authenticated

      serialize(paginate(current_account.featured))
    end

    # Adds Facebook connect to the account
    # 
    # Requires authentication
    post "/facebook" do
      control_access :authenticated

      current_user.private_metadata["fb_access_token"] = request_body["fb_auth_token"]
      current_user.facebook_uid = request_body["fb_uid"]
      if user.save
        [200, ""]
      else
        [400, "errors"]
      end
    end

    # Returns the account's history (posts, messages, etc.)
    # 
    # Requires authentication
    get "/history" do
      control_access :authenticated

      current_account.profile_history.to_json
    end
    
    # Returns the account's activity (post counts, thank counts, etc.)
    # 
    # Requires authentication
    get "/activity" do
      control_access :authenticated
      
      serialize(current_account.activity)
    end

  end
end
