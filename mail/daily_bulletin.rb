class DailyBulletin < MailBase

  def initialize(user_id, date)
    @user, @date = User.find(user_id), DateTime.parse(date)
  end

  def user 
    @user
  end

  def logo_url
    asset_url("/images/logo2.png")
  end

  def reply_button_url
    asset_url("/images/mail/reply-button.png")
  end

  def invite_them_now_button_url
    asset_url("/images/mail/invite-them-now-button.png")
  end
  
  def short_user_name
    @user.first_name
  end

  def subject
    "The CommonPlace #{community_name} Daily Bulletin"
  end

  def header_text
    @date.strftime("%A, %B %d, %Y")
  end

  def community
    @user.community
  end

  def community_name
    community.name
  end

  def deliver?
    posts_present || announcements_present || events_present
  end

  def posts_present
    posts.present?
  end
  
  def posts
    @posts ||= community.posts.today.map do |post|
      Serializer::serialize(post).tap do |post|
        post['replies'].each {|reply| 
          reply['published_at'] = reply['published_at'].strftime("%l:%M%P") 
          reply['avatar_url'] = asset_url(reply['avatar_url'])
        }
        post['avatar_url'] = asset_url(post['avatar_url'])
        post['url'] = url(post['url'])
      end
    end
  end

  def announcements_present
    announcements.present?
  end

  def announcements
    @announcements ||= community.announcements.today.map do |announcement|
      Serializer::serialize(announcement).tap do |announcement|
        announcement['replies'].each {|reply| 
          reply['published_at'] = reply['published_at'].strftime("%l:%M%P") 
          reply['avatar_url'] = asset_url(reply['avatar_url'])
        }
        announcement['avatar_url'] = asset_url(announcement['avatar_url'])
        announcement['url'] = url(announcement['url'])
      end
    end
  end

  def events_present
    events.present?
  end

  def events
    @events ||= community.events.between(@date, @date.advance(:weeks => 1)).map do |event|
      
      Serializer::serialize(event).tap do |event|
        event['replies'].each {|reply| 
          reply['published_at'] = reply['published_at'].strftime("%l:%M%P") 
          reply['avatar_url'] = asset_url(reply['avatar_url'])
        }
        event["short_month"] = event['occurs_on'].strftime("%b")
        event["day"] = event['occurs_on'].strftime("%d")
        event['url'] = url(event['url'])
      end
    end
  end
end
