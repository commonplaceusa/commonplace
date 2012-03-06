class API
  class Neighborhoods < Unauthorized

    get "/:id/posts" do |id|
      posts = Post.includes(:user).where(:users => {:neighborhood_id => id}).
        reorder("posts.replied_at")

      serialize(paginate(posts.includes(:user, :replies)))
    end

  end
end
