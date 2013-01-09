class FlagNotification < ThankNotification

  self.template_file = ThankNotification.template_file

  def initialize(warn_id)
    @thank = Warning.find(warn_id)
    @user = @thank.warnable.user
    @neighbor = @thank.user
    @thankable = @thank.warnable
  end

  def to
    "organizing@ourcommonplace.com"
  end

  def short_user_name
    "OurCommonPlace organizers"
  end

  def subject
    "#{user_name}'s post was flagged"
  end

  def content
    "just flagged #{user_name}'s post "
  end

  def has_content_url
    true
  end

  def extra_content
    " in OurCommonPlace #{community.name}. This post has been flagged #{num_flags} times."
  end

  def num_flags
    @thankable.all_flags.count
  end
end
