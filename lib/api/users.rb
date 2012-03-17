class API
  class Users < Base

    helpers do
      # Finds the user from the request params
      # 
      # Returns a user or halts with status code 404
      def find_user
        @user ||= User.find(params[:id]).tap {|u| u || (halt 404) }
      end
    end
  
    # Creates a message from the current user to the user
    #
    # Request params:
    #   subject - The message subject
    #   body - The body of the message
    # 
    # Returns 200 on success, 400 if there were validation errors
    post "/:id/messages" do |id|
      control_access :community, find_user.community

      message = Message.new(:subject => request_body['subject'],
                            :body => request_body['body'],
                            :messagable => find_user,
                            :user => current_user)
      if message.save
        kickoff.deliver_user_message(message)
        [200, ""]
      else
        [400, "errors"]
      end
    end

    # Gets a list of the users history
    get "/:id/history" do
      control_access :community, find_user.community
      find_user.profile_history.to_json
    end

    # Gets the users data
    get "/:id" do |id|
      control_access :community, find_user.community
      serialize find_user
    end
    
    # Returns a list of all the users posts of any type
    get "/:id/postlikes" do
      control_access :community, find_user.community
      
      search = Sunspot.search([Announcement, Post, GroupPost, Event]) do
        order_by(:created_at, :desc)
        paginate(:page => params["page"].to_i + 1, :per_page => params["limit"])
        with(:community_id, find_user.community.id)
        any_of do
          with(:user_id, find_user.id)
          with(:reply_author_ids, find_user.id)
        end
      end
      serialize(search)
    end

  end
end
