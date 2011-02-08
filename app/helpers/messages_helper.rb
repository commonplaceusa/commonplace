module MessagesHelper

  def other_participant(message)
    if message.user == current_user
      message.messagable
    else
      message.user
    end
  end

end
