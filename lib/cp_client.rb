
class CPClient
  
  def initialize(options = {})
    @host = options[:host]
    @authentication = options[:api_key]
  end

  def community_posts(community, options = {})
    get("/communities/#{community}/posts", options)
  end

  def neighborhood_posts(neighborhood, options = {})
    get("/neighborhoods/#{neighborhood}/posts", options)
  end

  def community_events(community, options = {})
    get("/communities/#{community}/events", options)
  end

  def community_publicity(community, options = {})
    get("/communities/#{community}/announcements", options)
  end

  def community_group_posts(community, options = {})
    get("/communities/#{community}/group_posts", options)
  end

  def community_neighbors(community, options = {})
    get("/communities/#{community}/users", options)
  end

  def community_feeds(community, options = {})
    get("/communities/#{community}/feeds", options)
  end
  
  def community_groups(community, options = {})
    get("/communities/#{community}/groups", options)
  end

  def post_info(id)
    get("/posts/#{id}")
  end

  def user_info(id)
    get("/users/#{id}")
  end

  def addresses_for_community(community, options = {})
    get("/communities/#{community.id}/addresses", options)
  end

  private

  def connection
    @_connection ||= Faraday.new(:url => @host, :headers => {"AUTHORIZATION" => @authentication})
  end
  
  def get(uri, params = {})
    JSON.parse connection.get {|req| req.url uri, params}.body
  end
  
end
