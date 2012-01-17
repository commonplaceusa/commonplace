class API
  class Users < Base

    post "/:id/messages" do |id|
      user = User.find(id)
      halt [401, "wrong community"] unless in_comm(user.community.id)
      message = Message.new(:subject => request_body['subject'],
                            :body => request_body['body'],
                            :messagable => user,
                            :user => current_account)
      if message.save
        kickoff.deliver_user_message(message)
        [200, ""]
      else
        [400, "errors"]
      end
    end

    post "/users/:id/update_avatar_and_fb_auth" do |id|
      user = User.find(id)
      halt [401, "wrong community"] unless in_comm(user.community.id)
      # Update the user object
      user.metadata['fb_access_token'] = request_body['fb_auth_token']
      user.facebook_uid = request_body['fb_username']
      if user.save
        [200, ""]
      else
        [400, "errors"]
      end
    end

    get "/user_by_email/:email" do |email|
      user = User.find_by_email(email)
      halt [401, "wrong community"] unless current_user.admin
      user.to_json
    end

    get "/:id" do |id|
      user = User.find(id)
      halt [401, "wrong community"] unless in_comm(user.community.id)
      serialize user
    end

  end
end
