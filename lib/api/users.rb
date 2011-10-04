class API
  class Users < Base

    post "/:id/messages" do |id|
      message = Message.new(:subject => request_body['subject'],
                            :body => request_body['body'],
                            :messagable => User.find(id),
                            :user => current_account)
      if message.save
        kickoff.deliver_user_message(message)
        [200, ""]
      else
        [400, "errors"]
      end
    end

    get "/:id" do |id|
      serialize User.find(id)
    end

  end
end
