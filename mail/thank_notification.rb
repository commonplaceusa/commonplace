
class ThankNotification < MailBase

  def initialize(thank_id)
    @thank = Thank.find(thank_id)
    @user = @thank.thankable.user
    @thanker = @thank.user
    @thankable = @thank.thankable
  end


  def header_image_url
    asset_url("headers/#{community.slug}.png")
  end

  def user
    @user
  end

  def community
    @user.community
  end

  def subject
    "#{user_name} thanked you on CommonPlace!"
  end

  def short_user_name
    @user.first_name
  end

  def user_name
    @user.name
  end

  def thanker_name
    @thanker.name
  end

  def short_thanker_name
    @thanker.first_name
  end

  def thanked_for
    if @thankable.is_a?(Reply)
      "reply on \"#{@thankable.repliable.subject}\""
    else 
      "\"#{@thankable.subject}\" post"
    end
  end

  def message_thanker_url
    
  end
  
  def thanker_profile_url

  end

  def community_slug
    community.slug
  end
end
