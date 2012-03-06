class API
  
  class Base < Sinatra::Base

    enable :raise_errors
    enable :logging
    enable :dump_errors
    
    helpers do

      def current_user
        @_user ||= warden.user(:user)
      end
      
      alias :current_account :current_user
      
      def warden
        env["warden"]
      end

      def request_body
        @_request_body ||= JSON.parse(request.body.read.to_s)
      end

      def authorize!
        halt [401, "not logged in"] unless warden.authenticated?(:user)
      end

      def serialize(thing)
        Serializer::serialize(thing).to_json
      end

      def page
        (params[:page] || 0).to_i
      end

      def limit
        (params[:limit] || 25).to_i
      end

      def paginate(scope)
        limit.to_i == 0 ? scope : scope.limit(limit).offset(limit * page)
      end

      def kickoff
        request.env["kickoff"] ||= KickOff.new
      end

      def last_modified_by_replied_at(scope)
        # sets last modified header for this request to that of the newest record
        last_modified_item = scope.unscoped.order("GREATEST(replied_at, updated_at) DESC").first
        last_thank = Thank.order("created_at DESC").first

        last_modified([
            last_modified_item.try(:replied_at),
            last_modified_item.try(:updated_at),
            last_thank.try(:created_at),
            Date.today.beginning_of_day].compact.max)
      end

      def jsonp(callback, data)
        "#{callback}(#{data})"
      end

      def in_comm(community_id)
        current_user.community.id == community_id.to_i || current_user.admin
      end

      def thank(scope, id)
        post = scope.find(id)
        halt [401, "wrong community"] unless in_comm(post.community.id)
        halt [400, "errors: already thanked"] unless post.thanks.index { |t| t.user.id == current_account.id } == nil
        thank = Thank.new(:user_id => current_account.id,
                         :thankable_id => id,
                         :thankable_type => scope.to_s)
        if thank.save
          if scope == Reply
            serialize scope.find(id).repliable
          else
            serialize scope.find(id)
          end
        else
          [400, "errors"]
        end
      end

      NO_CALLBACK = ["no_callback"].to_json

    end

    before do 
      cache_control :public, :must_revalidate, :max_age => 0
      content_type :json
    end

  end
  
  class Authorized < Base
  
    before do
      authorize!
    end
  
  end
  
  class Unauthorized < Base
    
    before do
      if request.method != "GET"
        authorize!
      end
    end
  
  end
  
end
