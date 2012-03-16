class API
  class Sessions < Unauthorized

    # Public: sets a cookie which maintains the login session using warden
    # 
    # POST params - The users authentication method
    #   email - The users's password
    #   password - The user's password
    #
    # Returns 200 and sets the cookie on success
    # Returns 401 on failure
    post "/" do
      user = User.find_by_email(request_body['email'])
      if user && user.valid_password?(request_body['password'])
        warden.set_user(user, :scope => :user)
      else
        401
      end
    end

  end
end
