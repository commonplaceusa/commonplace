class API
  class Postlikes < Base

    # This api should not be mounted. It is an abstract api that relies
    # on definitions of helpers (klass and update_attributes) defined
    # in the apis that inherit from it. Announcements, Events, Posts,
    # and GroupPosts

    helpers do
      # Find the postlike or halt with 404
      def find_postlike
        @postlike ||= klass.find_by_id(params[:id]) || (halt 404)
      end
    end

    # Updates the postlike post like with the given params
    #
    # Requires ownership
    #
    # Returns the serialized Postlike if saved
    # Returns 400 and error info if not saved
    put "/:id" do
      control_access :owner, find_postlike
            
      if update_attributes
        serialize find_postlike
      else
        [400, "errors: #{find_postlike.errors.full_messages.to_s}"]
      end
    end

    # Destroys the postlike
    #
    # Requires ownership
    #
    # Returns 200
    delete "/:id" do
      control_access :owner, find_postlike

      find_postlike.destroy
      200
    end

    # Returns the serialized postlike
    # 
    # Requires communtiy membership
    get "/:id" do
      control_access :community_member, find_postlike.community

      serialize find_postlike
    end

    # Adds a thank to the postlike
    #
    # Requires community membership
    # 
    # Returns the serialized Thank if successful
    # Returns 400 on validation errors
    post "/:id/thank" do
      control_access :community_member, find_postlike.community

      thank(find_postlike.class, find_postlike.id)
    end
    
    # Adds a reply to the postlike
    #
    # Kicks off a job to deliver the reply
    # 
    # Requires community membership
    #
    # Request params:
    #  body - the reply text
    # 
    # Returns the serialized reply if successful
    # Returns 400 if there are validation errors
    post "/:id/replies" do
      control_access :community_member, find_postlike.community
      
      reply = Reply.new(:repliable => find_postlike,
                        :user => current_user,
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
