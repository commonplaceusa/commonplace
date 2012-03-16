class API
  class Neighborhoods < Base

    helpers do 

      # Finds the neighborhood by params[:id] or halts with 404
      def find_neighborhood
        @neighborhood ||= Neighborhood.find_by_id(params[:id]) || (halt 404)
      end

    end

    # Lists the neighborhood's posts
    # 
    # Requires community membership
    get "/:id/posts" do |id|
      control_access :community_member, find_neighborhood.community

      posts = Post.includes(:user).
        where(:users => {:neighborhood_id => find_neighborhood.id}).
        reorder("posts.replied_at")

      serialize(paginate(posts.includes(:user, :replies)))
    end

  end
end
