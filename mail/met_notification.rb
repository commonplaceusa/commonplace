class MetNotification < ThankNotification

  self.template_file = ThankNotification.template_file

  def initialize(user_id, neighbor_id)
    @user = User.find(user_id)
    @neighbor = User.find(neighbor_id)
  end

  def subject
    "#{neighbor_name} says they have met you on OurCommonPlace!"
  end

  def content
    "just told us that they know you! 
    
    Go to "
  end

  def has_content_url
    true
  end

  def content_url
    neighbor_profile_url
  end

  def content_url_text
    "#{short_neighbor_name}'s profile "
  end

  def extra_content
    "on OurCommonPlace #{community.name} and confirm that you know them."
  end

end
