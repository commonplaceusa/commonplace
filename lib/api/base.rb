class API
  
  class Base < Sinatra::Base
    
    helpers do

      def current_account
        @_user ||= if request.env["HTTP_AUTHORIZATION"].present?
                     User.find_by_authentication_token(request.env["HTTP_AUTHORIZATION"])
                   elsif params['authentication_token'].present?
                     User.find_by_authentication_token(params[:authentication_token])
                   else
                     User.find_by_authentication_token(request.cookies['authentication_token'])
                   end
      end

      def current_user
        current_account
      end

      def request_body
        @_request_body ||= JSON.parse(request.body.read.to_s)
      end

      def authorize!
        halt [401, "not logged in"] unless current_user
      end

      def serialize(thing)
        Serializer::serialize(thing).to_json
      end

      def logger
        @logger ||= Logger.new(Rails.root.join("log", "api.log"))
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

      def last_modified_by_updated_at(scope)
        # sets last modified header for this request to that of the newest record
        last_modified(scope.unscoped
                        .reorder("updated_at DESC")
                        .select('updated_at')
                        .first.try(&:updated_at))
      end

      def jsonp(callback, data)
        "#{callback}(#{data})"
      end

      def in_comm(community_id)
        current_user.community.id == community_id || current_user.admin
      end
      
      NO_CALLBACK = ["no_callback"].to_json

    end

    before do 
      cache_control :public, :must_revalidate, :max_age => 0
      content_type :json
      authorize!
    end

  end
  
end
