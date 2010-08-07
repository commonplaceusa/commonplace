module TextHelper
  
  def user_organization_text
    if current_user.managable_organizations.length == 0 
      "Start an organization"
    else
      "Manage Organizations"
    end
  end

  def display_or_none(field)
    field || '<span class="none">none listed</span>'
  end
  
  # Move me to User.rb!
  def user_inbox_size
    "Inbox (1)"
  end
  
  
end