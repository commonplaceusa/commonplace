class API
  
  class Base < Sinatra::Base
    def public_api
      false
    end

    enable :raise_errors
    enable :logging
    enable :dump_errors

    before do
      cache_control :public, :must_revalidate, :max_age => 0
      content_type :json
      authorize! unless public_api
    end

    helpers do

      def current_account
        token = request.env["HTTP_AUTHORIZATION"] ||
                params['authentication_token'] ||
                request.cookies['authentication_token']

        @_user ||= User.find_by_authentication_token token
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
        current_user.community.id == community_id.to_i || current_user.admin
      end

      NO_CALLBACK = ["no_callback"].to_json

    end

  end
  
end
