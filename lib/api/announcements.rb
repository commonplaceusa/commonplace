class API
  class Announcements < Postlikes

    helpers do

      def auth(announcement)
        halt [403, "wrong community"] unless in_comm(announcement.community.id)
        if (announcement.owner_type == "Feed")
          announcement.owner.get_feed_owner(current_account) or current_account.admin
        else
          announcement.owner == current_account or announcement.user == current_account or current_account.admin
        end
      end
      
      def klass
        Announcement
      end
      
      def set_attributes(announcement, request_body)
        announcement.subject = request_body["title"]
        announcement.body = request_body["body"]
        announcement.tag_list = request_body["tags"]
      end

    end
    
  end
end
