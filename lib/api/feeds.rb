class API
  class Feeds

    post "/:id/announcements" do |feed_id|
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

    get "/:id/announcements" do |feed_id|
      scope = Announcement.where("owner_id = ? AND owner_type = ?", feed_id, "Feed")
      serialize(paginate(scope.includes(:replies, :owner).reorder("updated_at DESC")))
    end

    post "/:id/events" do |feed_id|
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

    get "/:id/events" do |feed_id|
      scope = Event.where("owner_id = ? AND owner_type = ?",feed_id, "Feed")
      serialize(paginate(scope.upcoming.includes(:replies).reorder("date ASC")))
    end

    get "/:id/subscribers" do |feed_id|
      serialize(paginate(Feed.find(feed_id).subscribers))
    end

    post "/:id/invites" do |feed_id|
      kickoff.deliver_feed_invite(request_body['emails'], Feed.find(feed_id))
      [200, ""]
    end

    post "/:id/messages" do |feed_id|
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
    
    get "/:id" do |id|
      serialize(id =~ /[^\d]/ ? Feed.find_by_slug(id) : Feed.find(id))
    end

  end
end
