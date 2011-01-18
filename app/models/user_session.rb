class UserSession < Authlogic::Session::Base
  oauth2_client_id     CONFIG["facebook_api_key"]
  oauth2_client_secret CONFIG["facebook_secret_key"]
  oauth2_site          "https://graph.facebook.com"
  oauth2_scope         "email,user_hometown"
end
