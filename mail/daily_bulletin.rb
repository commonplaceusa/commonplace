class DailyBulletin < MailBase

  def initialize(user_id, date)
    @user, @date = User.find(user_id), DateTime.parse(date)
  end

  def user 
    @user
  end
  
  def short_user_name
    @user.first_name
  end

  def subject
    "CommonPlace Daily Digest"
  end

  def header_text
    @date.strftime("%B %d, %Y")
  end

  def community
    @user.community
  end

  def community_name
    community.name
  end

  def deliver?
    posts.present?
  end
  
  def posts
    @posts ||= community.posts.between(@date.advance(:days => -1), @date).map do |post|
      {
        :subject => post.subject,
        :url => url("/posts/#{post.id}"),
        :user_short_name => post.user.first_name,
        :user_name => post.user.name,
        :user_avatar_url => url(post.user.avatar_url),
        :user_url => url("/users/#{post.user.id}"),
        :posted_at => post.created_at.strftime("%I:%M%P %b %d"),
        :body => markdown(post.body),
        :num_more_replies => post.replies.count > 2 ? post.replies.count - 2 : nil,
        :replies => post.replies.take(2).map do |reply| 
          {
            :user_name => reply.user.name,
            :posted_at => reply.created_at.strftime("%I:%M%P %b %d"),
            :body => reply.body,
            :user_avatar_url => url(reply.user.avatar_url)
          }
        end
      }
    end
  end

  def announcements?
    !announcements.empty?
  end

  def announcements
    @announcements ||= user.daily_subscribed_announcements.select {|a|
      @date.advance(:days => -1) < a.created_at && a.created_at < @date 
    }.map do |announcement|
      {
        :subject => announcement.subject,
        :url => url("/announcements/#{announcement.id}"),
        :owner_name => announcement.owner.name,
        :owner_avatar_url => url(announcement.owner.avatar_url),
        :owner_url => url("/feeds/#{announcement.owner.id}"),
        :posted_at => announcement.created_at.strftime("%I:%M%P %b %d"),
        :body => markdown(announcement.body),
        :num_more_replies => announcement.replies.count > 2 ? announcement.replies.count - 2 : nil,
        :replies => announcement.replies.take(2).map do |reply| 
          {
            :user_name => reply.user.name,
            :posted_at => reply.created_at.strftime("%I:%M%P %b %d"),
            :body => reply.body,
            :user_avatar_url => url(reply.user.avatar_url)
          }
        end
      }
    end
  end

  def events?
    !events.empty?
  end

  def events
    @events ||= community.events.between(@date, @date.advance(:weeks => 1)).map do|event|
      { :name => event.name,
        :posted_at => event.created_at.strftime("%I:%M%P %b %d"),
        :posted_by => event.owner.name,
        :body => event.description,
        :date => {
          :short_month => event.date.strftime("%b"),
          :day => event.date.strftime("%d")
        },
        :time => {
          :start => event.start_time.try(:strftime,"%l:%M%P") || "?",
          :end => event.end_time.try(:strftime,"%l:%M%P") || "?"
        },
        :url => url("/events/#{event.id}"),
        :num_more_replies => event.replies.count > 2 ? event.replies.count - 2 : nil,
        :venue => event.venue.present? ? event.venue : "--",
        :address => event.address.present? ? event.address : "--",
        :replies => event.replies.take(2).map do |reply| 
          { :user_avatar_url => url(reply.user.avatar_url(:thumb)),
            :posted_by => reply.user.name,
            :body => reply.body,
            :posted_at => reply.created_at.strftime("%I:%M%P %b %d")
          }
        end
      }
    end
  end
  
end
