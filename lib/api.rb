require 'rack/contrib/jsonp'
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

      map("/") { run lambda {|env|  [200, {}, "HI!"] } }
    end
  end

  def call(env)
    @app.call(env)
  end

  def self.call(env)
    new.call(env)
  end

end

