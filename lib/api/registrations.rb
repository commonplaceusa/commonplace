class API
  class Registrations < Base
    # todo: can we skip the registration class and go right to a user?
    def public_api
      true
    end

    get "/validate_email" do
      ok({available: User.find_by_email(params[:email]).nil?})
    end

    post '/add_profile' do
      authorize!

      if current_user.update_attributes params[:registration]
        params = {}
        params.merge!({avatar: current_user.avatar_url}) if current_user.avatar?
        ok(params)
      else
        error(current_user.errors.messages)
      end
    end

    post '/crop_avatar' do
      authorize!

      if current_user.update_attributes params[:registration]
        ok
      else
        error(current_user.errors.messages)
      end
    end

    post '/add_feeds' do
      authorize!
      current_user.feed_ids = params[:feed_ids]
      if current_user.save
        ok
      else
        error(current_user.errors.messages)
      end
    end

    post '/add_groups' do
      authorize!
      current_user.feed_ids = params[:feed_ids]
      current_user.save
      # todo: no error handling here b/c no ajax
      redirect root_url << '/#tour'
    end

    protected

    # todo: move to base
    def ok(options = {})
      content_type 'application/json'
      [200, {status: 'ok'}.merge(options).to_json]
    end

    def error(options = {})
      content_type 'application/json'
      [500, {status: 'error'}.merge(options).to_json]
    end

  end
end
