class API
  class Feeds < Base

    before "/:feed_id/*" do |feed_id, stuff|
      feed = feed_id =~ /[^\d]/ ? Feed.find_by_slug(feed_id) : Feed.find(feed_id)
      halt [401, "wrong community"] unless in_comm(feed.community.id)
    end
    
    helpers do

      def auth(feed)
        feed.get_feed_owner(current_account) or current_account.admin
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
      serialize(paginate(scope.includes(:replies, :owner).reorder("updated_at DESC")))
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

    get "/:feed_id/subscribers" do |feed_id|
      serialize(paginate(Feed.find(feed_id).subscribers))
    end

    post "/:feed_id/invites" do |feed_id|
      halt [401, "unauthorized"] unless auth(Feed.find(feed_id))
      kickoff.deliver_feed_invite(request_body['emails'], Feed.find(feed_id))
      [200, ""]
    end

    post "/:feed_id/messages" do |feed_id|
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
      if Feed.find(feed_id).get_feed_owner(current_user)
        serialize(Feed.find(feed_id).feed_owners)
      else
        [401, "unauthorized"]
      end
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

  end
end
