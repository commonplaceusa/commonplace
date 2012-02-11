class API
  class Registrations < Unauthorized
    
    get "/:community_id/validate" do |community_id|
      user = User.new(:full_name => params["full_name"],
                      :email => params["email"],
                      :address => params["address"],
                      :community_id => community_id)
      
      serialize user
    end
    
    post "/:community_id/new" do |community_id|
      halt [401, "already logged in"] if warden.authenticated?(:user)
      
      user = User.new(:full_name => params["full_name"],
                      :email => params["email"],
                      :address => params["address"],
                      :community_id => community_id,
                      :password => params["password"])
      
      if user.valid?
        user.about = params["about"]
        user.interest_list = params["interests"]
        user.skill_list = params["skills"]
        user.good_list = params["goods"]
        user.referral_source = params["referral_source"]
        user.referral_metadata = params["referral_metadata"]
        user.calculated_cp_credits = 0
        
        user.save
        warden.set_user(user, :scope => :user)
        serialize Account.new(current_user)
      else
        serialize user
      end
      
    end
    
    post "/:community_id/facebook" do |community_id|
      halt [401, "already logged in"] if warden.authenticated?(:user)
      
      user = User.(:full_name => params["full_name"],
                   :email => params["email"],
                   :community_id => community_id)
                   
      #set the user metadata to reflect the facebook info
      
      if user.save
        warden.set_user(user, :scope => :user)
      end
      serialize Account.new(current_user)
    end
    
    get "/:community_id" do |community_id|
      community = Community.find_by_id(community_id)
      
      serialize community.exterior
    end
    
  end
  
end
