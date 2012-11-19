class ThankNotification < MailBase

  def initialize(thank_id)
    @thank = Thank.find(thank_id)
    @user = @thank.thankable.user
    @neighbor = @thank.user
    @thankable = @thank.thankable
  end

  def user
    @user
  end

  def neighbor
    @neighbor
  end

  def community
    @user.community
  end

  def subject
    "#{neighbor_name} thanked you on OurCommonPlace!"
  end

  def content
    "just thanked you on OurCommonPlace for your #{thanked_for}"
  end

  def has_content_url
    true
  end

  def content_url
    if @thankable.is_a?(Reply)
      show_post_url(@thankable.repliable.id)
    else
      show_post_url(@thankable.id)
    end
  end

  def content_url_text
    if @thankable.is_a?(Reply)
      "\"#{@thankable.repliable.subject}\""
    else
      "\"#{@thankable.subject}\""
    end
  end

  def extra_content
    ""
  end

  def short_user_name
    @user.first_name
  end

  def user_name
    @user.name
  end

  def neighbor_name
    @neighbor.name
  end

  def short_neighbor_name
    @neighbor.first_name
  end

  def thanked_for
    if @thankable.is_a?(Reply)
      "reply on "
    else 
      "post "
    end
  end

  def neighbor_profile_url
    show_user_url(@neighbor.id)
  end

end
