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

    # Adds a warning to the postlike
    #
    # Requires community membership
    #
    # Returns the serialized Warning if successful
    # Returns 400 on validation errors
    post "/:id/flag" do
      control_access :community_member, find_postlike.community

      flag(find_postlike.class, find_postlike.id)
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

    # Shares the postlike via e-mail to a CSV list of addresses
    #
    # Kicks off a job to deliver the e-mail(s)
    #
    # Requires community membership
    #
    # Request params:
    #  recipients - comma-separated list of e-mail addresses to send to
    #
    # Returns 400 if there are errors
    # Returns 200 if successful
    post "/:id/share_via_email" do
      postlike = find_postlike
      control_access :community_member, postlike.community

      recipients = params['recipients'].split(',').map(&:strip)
      kickoff.deliver_email_share(recipients, postlike.id, postlike.class.name, postlike.community.id, current_user.id)
      200
    end

    # Adds an Image to the postlike
    #
    # Requires community membership - should be ownership
    #
    # Request params:
    #  image_id - the id of the Image
    #
    # Returns the serialized Image if successful
    # Returns 400 if there are validation errors
    post "/:id/add_image" do
      control_access :community_member, find_postlike.community

      params[:image_id].each do |i|
        image = Image.find_by_id(i)
        image.update_attributes(
          imageable: find_postlike
        )

        if image.save
          serialize image
        else
          [400, "errors"]
        end
      end
    end

    # Uploads an image
    #
    # Requires authentication
    #
    # Request params:
    #   image[:tempfile] - an image
    #
    # Returns the serialized image
    post "/image" do
      control_access :authenticated

      photo = Image.new(:user => current_user)
      photo.image = params[:image][:tempfile]
      photo.image.instance_write(:image_file_name, params[:image][:filename])

      if photo.save
        response.headers["Content-Type"] = "text/html; charset=utf-8" #set this to make sure IE compatibility
        [200, serialize(photo) ]
      else
        [400, "errors"]
      end
    end
  end
end
