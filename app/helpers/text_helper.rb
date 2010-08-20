module TextHelper
  
  def user_organization_text
    if current_user.managable_organizations.length == 0 
      "Start an organization"
    else
      "Manage Organizations"
    end
  end

  def reply_count(item)
    if item.replies.length == 0
      "no replies yet"
    else
      "(#{self.replies.length}) replies"
    end
  end
  
end
