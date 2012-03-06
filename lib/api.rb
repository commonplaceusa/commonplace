require 'rack/contrib/jsonp'
require_all Rails.root.join("lib", "api", "*.rb")

class API

  def initialize
    @app = Rack::Builder.new do

      use Rack::JSONP
      
      use Rack::Session::Cookie, # share session w/ rails. replaces enable :sessions
        :key => Commonplace::Application.config.session_options[:key],
        :secret => Commonplace::Application.config.secret_token
      
      map("/account") { run Accounts }
      map("/announcements") { run Announcements }
      map("/communities") { run Communities }
      map("/contacts") { run Contacts }
      map("/events") { run Events }
      map("/feeds") { run Feeds }
      map("/users") { run Users }
      map("/group_posts") { run GroupPosts }
      map("/groups") { run Groups }
      map("/messages") { run Messages }
      map("/neighborhoods") { run Neighborhoods }
      map("/posts") { run Posts }
      map("/replies") { run Replies }
      map("/stats") { run Stats }
      map("/registration") { run Registrations }
      map("/swipe") { run Swipes }
      map("/sessions") { run Sessions }

      map("/integration") { run Integration }

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
