class API
  class Neighborhoods < Base

    get "/:id/posts" do |id|
      posts = Post.includes(:user).where(:users => {:neighborhood_id => id}).
        reorder("posts.updated_at")

      serialize(paginate(posts.includes(:user, :replies)))
    end

  end
end
