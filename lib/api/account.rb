class API
  class Account < Base

    get "/" do 
      serialize CPAccount.new(current_account)
    end

    post "/subscriptions/feeds" do
      current_account.feeds << Feed.find(params[:id] || request_body['id'])
      serialize(CPAccount.new(current_account))
    end

    delete "/subscriptions/feeds/:id" do |id|
      current_account.feeds.delete(Feed.find(id))
      serialize(CPAccount.new(current_account))
    end
    
    post "/subscriptions/groups" do 
      current_account.groups << Group.find(params[:id] || request_body['id'])
      serialize(CPAccount.new(current_account))
    end

    delete "/subscriptions/groups/:id" do |id|
      current_account.groups.delete(Group.find(id))
      serialize(CPAccount.new(current_account))
    end

    post "/mets" do
      current_account.people << User.find(params[:id] || request_body["id"])
      serialize(CPAccount.new(current_account))
    end

    delete "/mets/:id" do |id|
      current_account.people.delete(User.find(id))
      serialize(CPAccount.new(current_account))
    end
    
    get "/inbox" do 
      serialize(paginate(current_account.inbox.reorder("updated_at DESC")))
    end

    get "/inbox/sent" do
      serialize(paginate(current_account.sent_messages.reorder("updated_at DESC")))
    end

  end
end
