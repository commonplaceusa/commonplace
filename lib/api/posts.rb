class API
  class Posts < Postlikes

    helpers do
    
      def auth(post)
        halt [403, "wrong community"] unless in_comm(post.community.id)
        post.user == current_account or current_account.admin
      end
      
      def klass
        Post
      end
      
      def set_attributes(post, request_body)
        post.subject = request_body["title"]
        post.body = request_body["body"]
        post.category = request_body["category"]
      end

    end
    
  end
end
