module AuthlogicOauth2

  module Session

    module Methods
     def oauth2_client_id
        is_auth_session? ? self.class.oauth2_client_id : session_class.oauth2_client_id
      end

      def build_callback_url
        oauth2_controller.url_for :controller => oauth2_controller.controller_name, :action => oauth2_controller.action_name
      end
      
      def generate_access_token
        oauth2_client.web_server.get_access_token(oauth2_controller.params[:code], :redirect_uri => build_callback_url)
      end
      
      def oauth2_response
        oauth2_controller.params && oauth2_controller.params[:code]
      end
      
      def oauth2_client
        OAuth2::Client.new(oauth2_client_id, oauth2_client_secret, :site => oauth2_site)
      end
      
      # Convenience method for accessing the session controller
      def oauth2_controller
        is_auth_session? ? controller : session_class.controller
      end
      
      # Convenience methods for accessing session configuration values
      def oauth2_client_id
        is_auth_session? ? self.class.oauth2_client_id : session_class.oauth2_client_id
      end
      
      def oauth2_client_secret
        is_auth_session? ? self.class.oauth2_client_secret : session_class.oauth2_client_secret
      end
      
      def oauth2_site
        is_auth_session? ? self.class.oauth2_site : session_class.oauth2_site
      end
      
      def oauth2_scope
        is_auth_session? ? self.class.oauth2_scope : session_class.oauth2_scope
      end
      
      def is_auth_session?
        self.is_a?(Authlogic::Session::Base)
      end
      def authenticate_with_oauth2
        if @record
          self.attempted_record = record
        else
          access_token = generate_access_token
          json = JSON.parse(access_token.get('/me'))
          if self.attempted_record = User.find_by_facebook_uid(json['id'])
            self.attempted_record.oauth2_token = access_token.token
            self.attempted_record.save
          end
        end
        
        if !attempted_record
          errors.add_to_base("Could not find user in our database, have you registered with your Oauth2 account?")
        end
      end
    end
  end
end
