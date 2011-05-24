class API < Sinatra::Base
  
  helpers do
    
    def current_account
      @_user ||= User.find_by_id(session['user_credentials_id']) 
    end

    def authenticate!
      current_account || halt(401)
    end

  end

  
end
