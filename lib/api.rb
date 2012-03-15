require 'rack/contrib/jsonp'
%w{ base accounts announcements communities contacts events
    feeds users group_posts groups messages
    neighborhoods posts registrations integration swipes }.each do |path|
  require Rails.root.join("lib", "api", path)
end

class API

  def initialize
    @app = Rack::Builder.new do

      use Rack::JSONP
      
      use Rack::Session::Cookie, # share session w/ rails. replaces enable :sessions
        :key => Commonplace::Application.config.session_options[:key],
        :secret => Commonplace::Application.config.secret_token
      
      use Warden::Manager do |manager|
        manager.failure_app = lambda { |env| [403, {}, ["Forbidden"]] }
      end

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
      map("/search/community") { run Search }
      map("/replies") { run Replies }
      map("/stats") { run Stats }
      map("/registration") { run Registrations }
      map("/swipe") { run Swipes }

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

class Warden::SessionSerializer
  def serialize(record)
   klass = record.class
   array = klass.serialize_into_session(record)
   array.unshift(klass.name)
  end
  
  def deserialize(keys)
    klass, *args = keys
    
    begin
      ActiveSupport::Inflector.constantize(klass).serialize_from_session(*args)
    rescue NameError => e
      if e.message =~ /uninitialized constant/
        Rails.logger.debug "[Warden] Trying to deserialize invalid class #{klass}"
        nil
      else
        raise
      end
    end
  end
end


