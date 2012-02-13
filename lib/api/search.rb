class API
  class Search < Authorized

    before "/:community_id/*" do |community_id, stuff|
      halt [401, "wrong community"] unless in_comm(params[:community_id])
    end

    helpers do
      
      def search(klass, params, community_id)
        search = Sunspot.search(klass) do
          keywords phrase(params["query"])
          paginate(:page => params["page"].to_i + 1)
          with(:community_id, community_id)
        end
        serialize(search)
      end

      def phrase(string)
        string.split('"').each_with_index.map { |object, i|
          i.odd? ? object : object.split(" ")
        }.flatten
      end

    end

    get "/:community_id/feeds" do |community_id|
      halt [200, {}, "[]"] if params["query"].blank?

      search(Feed, params, community_id)
    end

    get "/:community_id/groups" do |community_id|
      halt [200, {}, "[]"] if params["query"].blank?

      search(Group, params, community_id)
    end

    get "/:community_id/users" do |community_id|
      halt [200, {}, "[]"] if params["query"].blank?

      search(User, params, community_id)
    end

    get "/:community_id/group-like" do |community_id|
      halt [200, {}, "[]"] if params["query"].blank?

      search([Feed, Group, User], params, community_id)
    end

    get "/:community_id/post-like" do |community_id|
      halt [200, {}, "[]"] if params["query"].blank?

      search([Announcement, Event, Post, GroupPost], params, community_id)
    end

  end
end
