class API
  class GroupPosts < Postlikes

    helpers do
    
      def auth(post)
        halt [403, "wrong community"] unless in_comm(post.group.community.id)
        post.user == current_account or current_account.admin
      end
      
      def klass
        GroupPost
      end
      
      def set_attributes(post, request_body)
        post.subject = request_body["title"]
        post.body = request_body["body"]
      end

    end
    
  end
end
