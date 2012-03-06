class API
  class Users < Unauthorized

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

    get "/user_by_email/:email" do |email|
      user = User.find_by_email(email)
      halt [401, "wrong community"] unless current_user.admin
      user.to_json
    end

    get "/:id/history" do
      User.find(params[:id]).profile_history.to_json
    end

    get "/:id" do |id|
      user = User.find(id)
      halt [401, "wrong community"] unless in_comm(user.community.id)
      serialize user
    end
    
    get "/:user_id/postlikes" do |user_id|
      user = User.find(user_id)
      halt [401, "wrong community"] unless in_comm(user.community.id)
      
      search = Sunspot.search([Announcement, Post, GroupPost, Event]) do
        order_by(:created_at, :desc)
        paginate(:page => params["page"].to_i + 1, :per_page => params["limit"])
        with(:community_id, user.community.id)
        any_of do
          with(:user_id, user_id)
          with(:reply_author_ids, user_id)
        end
      end
      serialize(search)
    end

  end
end
