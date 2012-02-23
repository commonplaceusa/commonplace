class API
  class Accounts < Authorized

    helpers do

      def checked_inbox
        current_account.checked_inbox!
        serialize(Account.new(current_account))
      end

    end

    get "/" do 
      serialize Account.new(current_account)
    end
    
    put "/" do
      current_account.full_name = request_body["name"]
      current_account.about = request_body["about"]
      current_account.interest_list = request_body["interests"]
      current_account.skill_list = request_body["skills"]
      current_account.good_list = request_body["goods"]
      current_account.email = request_body["email"]
      current_account.post_receive_method = request_body["neighborhood_posts"]
      current_account.receive_weekly_digest = request_body["bulletin"]
      
      if current_account.save
        serialize Account.new(current_account)
      else
        [500, "could not save"]
      end
    end

    delete "/" do
      current_account.destroy
      [200]
    end

    post "/avatar" do
      current_account.avatar = params[:avatar][:tempfile]
      current_account.avatar.instance_write(:filename, params[:avatar][:filename])
      current_account.save
      serialize Account.new(current_account)
    end

    delete "/avatar" do
      current_account.avatar = nil
      current_account.save
      serialize Account.new(current_account)
    end
    
    put "/crop" do
      current_user.crop_x = request_body["crop_x"]
      current_user.crop_y = request_body["crop_y"]
      current_user.crop_w = request_body["crop_w"]
      current_user.crop_h = request_body["crop_h"]
      current_user.save
      serialize Account.new(current_user)
    end

     post "/metadata" do
       k = request_body['key']
       current_account.metadata[k] = request_body['value']
       current_account.save
       serialize Account.new(current_account)
     end

    post "/subscriptions/feeds" do
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

    delete "/subscriptions/feeds/:id" do |id|
      current_account.feeds.delete(Feed.find(id))
      serialize(Account.new(current_account))
    end
    
    post "/subscriptions/groups" do
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

    delete "/subscriptions/groups/:id" do |id|
      current_account.groups.delete(Group.find(id))
      serialize(Account.new(current_account))
    end

    post "/mets" do
      user = User.find(params[:id] || request_body["id"])
      halt [401, "wrong community"] unless in_comm(user.community.id)
      current_account.people << user
      serialize(Account.new(current_account))
    end

    delete "/mets/:id" do |id|
      current_account.people.delete(User.find(id))
      serialize(Account.new(current_account))
    end
    
    post "/neighbors" do
      request_body["neighbors"].each do |neighbor|
        first_name, last_name = neighbor["name"].split(" ", 2)
        resident = current_user.community
          .residents
          .find_by_first_name_and_last_name(first_name,last_name)

        resident.metadata[:friends] ||= []
        resident.metadata[:friends] << current_user.name
        resident.metadata[:can_contact] ||= request_body["can_contact"]
        resident.save
      end
      halt 200
    end
    
    get "/inbox" do
      checked_inbox()
      serialize(paginate(current_account.inbox.reorder("replied_at DESC")))
    end

    get "/inbox/sent" do
      serialize(paginate(current_account.sent_messages.reorder("replied_at DESC")))
    end

    get "/inbox/feeds" do
      checked_inbox()
      serialize(paginate(current_account.feed_messages.reorder("replied_at DESC")))
    end
    
    get "/featured" do
      serialize(paginate(current_account.featured))
    end
    
    post "/facebook" do
      current_user.private_metadata["fb_access_token"] = request_body["fb_auth_token"]
      current_user.facebook_uid = request_body["fb_uid"]
      if user.save
        [200, ""]
      else
        [400, "errors"]
      end
    end

    get "/history" do
      serialize(current_account.profile_history)
    end

  end
end
