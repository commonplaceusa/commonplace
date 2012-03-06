class API
  class Feeds < Unauthorized

    before "/:feed_id/*" do |feed_id, stuff|
      feed = feed_id =~ /[^\d]/ ? Feed.find_by_slug(feed_id) : Feed.find(feed_id)
      if !is_method("get")
        authorize!
        halt [403, "wrong community"] unless in_comm(feed.community_id)
      end
    end
    
    helpers do

      def auth(feed)
        feed.get_feed_owner(current_account) or current_account.admin
      end

    end
    
    put "/:feed_id" do |feed_id|
      feed = Feed.find(feed_id)
      halt [401, "unauthorized"] unless auth(feed)
      halt [404, "errors"] unless feed.present?
      
      feed.name = request_body["name"]
      feed.about = request_body["about"]
      feed.kind = request_body["kind"]
      feed.phone = request_body["phone"]
      feed.website = request_body["website"]
      feed.address = request_body["address"]
      feed.slug = request_body["slug"]
      feed.feed_url = request_body["rss"]
      
      if feed.save
        serialize(feed)
      else
        [500, "could not save"]
      end
    end

    post "/:feed_id/announcements" do |feed_id|
      halt [401, "unauthorized"] unless auth(Feed.find(feed_id))
      announcement = Announcement.new(:owner_type => "Feed",
                                      :owner_id => feed_id,
                                      :subject => request_body['title'],
                                      :body => request_body['body'],
                                      :community => current_account.community,
                                      :group_ids => request_body["groups"])
      if announcement.save
        kickoff.deliver_announcement(announcement)
        serialize(announcement)
      else
        [400, "errors"]
      end
    end

    get "/:feed_id/announcements" do |feed_id|
      scope = Announcement.where("owner_id = ? AND owner_type = ?", feed_id, "Feed")
      serialize(paginate(scope.includes(:replies, :owner).reorder("GREATEST(replied_at,created_at) DESC")))
    end

    post "/:feed_id/events" do |feed_id|
      halt [401, "unauthorized"] unless auth(Feed.find(feed_id))
      event = Event.new(:owner_type => "Feed",
                        :owner_id => feed_id,
                        :name => request_body['title'],
                        :description => request_body['about'],
                        :date => request_body['date'],
                        :start_time => request_body['start'],
                        :end_time => request_body['end'],
                        :venue => request_body['venue'],
                        :address => request_body['address'],
                        :tag_list => request_body['tags'],
                        :community => current_account.community,
                        :group_ids => request_body["groups"])
      if event.save
        serialize(event)
      else
        [400, "errors"]
      end
    end

    get "/:feed_id/events" do |feed_id|
      scope = Event.where("owner_id = ? AND owner_type = ?",feed_id, "Feed")
      serialize(paginate(scope.upcoming.includes(:replies).reorder("date ASC")))
    end
    
    post "/:feed_id/essays" do |feed_id|
      halt [401, "unauthorized"] unless auth(Feed.find(feed_id))
      essay = Essay.new(:feed_id => feed_id,
                        :user_id => current_user.id,
                        :subject => request_body["title"],
                        :body => request_body["body"])
      if essay.save
        serialize essay
      else
        [400, "errors"]
      end
    end
    
    get "/:feed_id/essays" do |feed_id|
      serialize(paginate(Feed.find(feed_id).essays))
    end

    get "/:feed_id/subscribers" do |feed_id|
      serialize(paginate(Feed.find(feed_id).subscribers))
    end

    post "/:feed_id/invites" do |feed_id|
      halt [401, "unauthorized"] unless auth(Feed.find(feed_id))
      kickoff.deliver_feed_invite(request_body['emails'], Feed.find(feed_id))
      [200, ""]
    end

    post "/:feed_id/messages" do |feed_id|
      authorize!
      message = Message.new(:subject => request_body['subject'],
                            :body => request_body['body'],
                            :messagable_type => "Feed",
                            :messagable_id => feed_id,
                            :user => current_account)
      if message.save
        [200, ""]
      else
        [400, "errors"]
      end
    end
    
    get "/:feed_id" do |feed_id|
      serialize(feed_id =~ /[^\d]/ ? Feed.find_by_slug(feed_id) : Feed.find(feed_id))
    end

    get "/:feed_id/owners" do |feed_id|
      authorize!
      if Feed.find(feed_id).get_feed_owner(current_user)
        serialize(Feed.find(feed_id).feed_owners)
      else
        [401, "unauthorized"]
      end
    end
    
    get "/:feed_id/swipes" do |feed_id|
      serialize(paginate(Feed.find(feed_id).swipes))
    end

    post "/:feed_id/owners" do |feed_id|
      feed = Feed.find(feed_id)
      halt [401, "unauthorized"] unless auth(feed)
      params["emails"].split(",").each do |email|
        user = User.find_by_email(email.gsub(" ",""))
        existing_owner = feed.get_feed_owner(user)
        if user and !existing_owner
          owner = FeedOwner.new(:feed => feed,
                                :user => user)
          owner.save
        end
      end
      [200, ""]
    end

    delete "/:feed_id/owners/:id" do |feed_id, id|
      halt [401, "unauthorized"] unless auth(Feed.find(feed_id))
      owner = FeedOwner.find(id)
      owner.destroy
    end
    
    post "/:feed_id/avatar" do |feed_id|
      feed = Feed.find(feed_id)
      halt [401, "unauthorized"] unless auth(feed)
      feed.avatar = params[:avatar][:tempfile]
      feed.avatar.instance_write(:filename, params[:avatar][:filename])
      feed.save
      serialize feed
    end
    
    delete "/:feed_id/avatar" do |feed_id|
      feed = Feed.find(feed_id)
      halt [401, "unauthorized"] unless auth(feed)
      feed.avatar = nil
      feed.save
      serialize feed
    end

  end
end
