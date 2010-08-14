module TextHelper
  
  def user_organization_text
    if current_user.managable_organizations.length == 0 
      "Start an organization"
    else
      "Manage Organizations"
    end
  end
  
  def link_to_add(item)
    
  end
  
  
end