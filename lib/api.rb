require 'rack/contrib/jsonp'

# todo: the following seems unnecessary
%w{ base accounts announcements communities events
    feeds users group_posts groups messages
    neighborhoods posts }.each do |path|
  require Rails.root.join("lib", "api", path)
end

class API

  def initialize
    @app = Rack::Builder.new do

      use Rack::JSONP

      use Rack::Session::Cookie, # share sessions w/ rails. replaces enable :sessions
          :key => Commonplace::Application.config.session_options[:key],
          :secret => Commonplace::Application.config.secret_token

      use Warden::Manager do |manager|
        manager.failure_app = lambda { |env| [403, {}, ["Forbidden"]] }
        #manager.serialize_into_session { |user| p "serialize to session: #{user}"; user.id }
        #manager.serialize_from_session { |id| p "serialize from session: #{id}"; User.find(id) }
      end

      map("/account") { run Accounts }
      map("/announcements") { run Announcements }
      map("/communities") { run Communities }
      map("/events") { run Events }
      map("/feeds") { run Feeds }
      map("/group_posts") { run GroupPosts }
      map("/groups") { run Groups }
      map("/messages") { run Messages }
      map("/neighborhoods") { run Neighborhoods }
      map("/posts") { run Posts }
      map("/registrations") { run Registrations }
      map("/replies") { run Replies }
      map("/search/community") { run Search }
      map("/users") { run Users }

      map("/") { run lambda { |env| [404, {}, ["Invalid Request"]] } }
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
  # replaces manager.serialize_into_session and manager.serialize_from_session
  # hackishly copied in from devise.  Session serialization syntax stays standard.
  def serialize(record) # untested
    klass = record.class
    array = klass.serialize_into_session(record)
    p "serializing in to session #{record}, #{klass}, #{array}"
    array.unshift(klass.name)
  end

  def deserialize(keys)
    klass, *args = keys

    begin
      p "deserialized: #{keys}, #{klass}"
      ActiveSupport::Inflector.constantize(klass).serialize_from_session(*args)
    rescue NameError => e
      if e.message =~ /uninitialized constant/
        Rails.logger.debug "[Devise] Trying to deserialize invalid class #{klass}"
        nil
      else
        raise
      end
    end
  end
end