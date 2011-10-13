class API
  class Announcements < Base

    helpers do

      def auth(announcement)
        if (announcement.owner_type == "Feed")
          announcement.owner.get_feed_Owner(current_account) or current_account.admin
        else
          announcement.owner == current_account or announcement.user == current_account or current_account.admin
        end
      end

    end

    put "/:id" do |id|
      announcement = Announcement.find(id)
      unless announcement.present?
        [404, "errors"]
      end

      announcement.subject = request_body['title']
      announcement.body = request_body['body']

      if auth(announcement) and announcement.save
        serialize(announcement)
      else
        unless auth(announcement)
          [401, 'unauthorized']
        else
          [500, 'could not save']
        end
      end
    end

    delete "/:id" do |id|
      announcement = Announcement.find(id)
      unless announcement.present?
        [404, "errors"]
      end

      if (auth(announcement))
        announcement.destroy
      else
        [404, "errors"]
      end
    end

    get "/:id" do |id|
      serialize Announcement.find(id)
    end

    post "/:id/replies" do |id|
      reply = Reply.new(:repliable => Announcement.find(id),
                        :user => current_account,
                        :body => request_body['body'])

      if reply.save
        kickoff.deliver_reply(reply)
        Serializer::serialize(reply).to_json
      else
        [400, "errors"]
      end
    end

  end
end
