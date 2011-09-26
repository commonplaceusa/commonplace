
class CPClient
  
  def initialize(options = {})
    @host = options[:host]
    @authentication = options[:api_key]
    @logger = options[:logger] || Rails.logger
  end

  def community_posts(community, options = {})
    get("/communities/#{community}/posts", options) { [] }
  end

  def neighborhood_posts(neighborhood, options = {})
    get("/neighborhoods/#{neighborhood}/posts", options) { [] }
  end

  def community_events(community, options = {})
    get("/communities/#{community}/events", options) { [] }
  end

  def community_publicity(community, options = {})
    get("/communities/#{community}/announcements", options) { [] }
  end

  def community_group_posts(community, options = {})
    get("/communities/#{community}/group_posts", options) { [] }
  end

  def community_neighbors(community, options = {})
    get("/communities/#{community}/users", options) { [] }
  end

  def community_feeds(community, options = {})
    get("/communities/#{community}/feeds", options) { [] }
  end
  
  def community_groups(community, options = {})
    get("/communities/#{community}/groups", options) { [] }
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

  def add_data_point(community,options)
    post("/communities/#{community.id}/add_data_point", options)
  end
  private

  def logger
    @logger
  end

  def connection
    @_connection ||= Faraday.new(:url => @host, :headers => {"AUTHORIZATION" => @authentication})
  end
  
  def get(uri, params = {}, &on_fail)
    request = connection.get {|req| req.url uri, params}
    if request.success?
      JSON.parse request.body
    else
      if on_fail
        result = on_fail.call
        logger.warn "GET #{uri} #{params.inspect} failed; falling back to #{result.inspect}"
        result
      else
        raise "GET #{uri} #{params.inspect} failed with no fallback"
      end
    end
  end

  def post(uri, params = {}, &on_fail)
    request = connection.post { |req| req.url uri, params }
    if request.success?
      true
    else
      if on_fail
        result = on_fail.call
        logger.warn "POST #{uri} #{params.inspect} failed; falling back to #{result.inspect}"
        result
      else
        raise "POST #{uri} #{params.inspect} failed with no fallback"
      end
    end
  end

end
