class API
  class Search < Base

    helpers do
      
      def search(klass, query, page)
        search = Sunspot.search(klass) do
          keywords query.split(" ")
          paginate(:page => page)
        end
        serialize(search.results)
      end

    end

    get "/" do
      halt [200, {}, "[]"]
    end

    get "/feeds" do
      halt [200, {}, "[]"] if params["query"].blank?

      search(Feed, params["query"], params["page"])
    end

    get "/groups" do
      halt [200, {}, "[]"] if params["query"].blank?

      search(Group, params["query"], params["page"])
    end

    get "/users" do
      halt [200, {}, "[]"] if params["query"].blank?

      search(User, params["query"], params["page"])
    end

    get "/group-like" do
      halt [200, {}, "[]"] if params["query"].blank?

      search([Feed, Group, User], params["query"], params["page"])
    end

    get "/announcements" do
      halt [200, {}, "[]"] if params["query"].blank?

      search(Announcement, params["query"], params["page"])
    end

    get "/events" do
      halt [200, {}, "[]"] if params["query"].blank?

      search(Event, params["query"], params["page"])
    end

    get "/posts" do
      halt [200, {}, "[]"] if params["query"].blank?

      search(Post, params["query"], params["page"])
    end

    get "/group-posts" do
      halt [200, {}, "[]"] if params["query"].blank?

      search(GroupPost, params["query"], params["page"])
    end

    get "/post-like" do
      halt [200, {}, "[]"] if params["query"].blank?

      search([Announcement, Event, Post, GroupPost], params["query"], params["page"])
    end

  end
end
