require 'rack/contrib/jsonp'
%w{ base accounts announcements communities events
    feeds users group_posts groups messages
    neighborhoods posts }.each do |path|
  require Rails.root.join("lib", "api", path)
end

class API

  def initialize
    @app = Rack::Builder.new do

      use Rack::JSONP

      map("/account") { run Accounts }
      map("/announcements") { run Announcements }
      map("/communities") { run Communities }
      map("/events") { run Events }
      map("/feeds") { run Feeds }
      map("/users") { run Users }
      map("/group_posts") { run GroupPosts }
      map("/groups") { run Groups }
      map("/messages") { run Messages }
      map("/neighborhoods") { run Neighborhoods }
      map("/posts") { run Posts }
      map("/search/community") { run Search }
      map("/replies") { run Replies }

      map("/") { run lambda {|env|  [404, {}, ["Invalid Request"]] } }
    end
  end

  def call(env)
    @app.call(env)
  end

  def self.call(env)
    new.call(env)
  end

end

