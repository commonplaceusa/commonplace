class WeeklyDigest < MailBase
  
  def initialize(user, start_date)
    @user = user
    @start_date = start_date
  end

  def start_date
    @start_date
  end
  
  def end_date
    start_date.advance(:weeks => 1)
  end

  def user 
    @user
  end
  
  def community
    user.community
  end

  def community_name
    community.name
  end

  def week_of
    start_date.strftime("%B %d")
  end

  def events
    community.events.between(end_date, 
                             end_date.advance(:weeks => 2)).map do |event|
      { :name => event.name,
        :posted_at => event.created_at.strftime("%I:%M%P %b %d"),
        :posted_by => event.owner.name,
        :body => event.description,
        :date => {
          :short_month => event.date.strftime("%b"),
          :day => event.date.strftime("%d")
        },
        :url => url("/events/#{event.id}"),
        :num_more_replies => event.replies.count > 2 ? event.replies.count - 2 : nil,
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

  def feeds_with_announcements
    community.announcements.between(start_date, end_date.end_of_day.utc).
      group_by(&:feed).to_a.map do |feed, announcements|
      { :avatar_url => url(feed.avatar_url),
        :name => feed.name,
        :subscribe_url => url("/feeds/#{feed.id}"),
        :url => url("/feeds/#{feed.id}"),
        :message_url => url("/feeds/#{feed.id}/messages/new"),
        :announcements => announcements.map do |announcement| 
          { :subject => announcement.subject,
            :url => url("/announcements/#{announcement.id}"),
            :posted_at => announcement.created_at.strftime("%I:%M%P %b %d"),
            :posted_by => announcement.feed.name,
            :body => announcement.body,
            :num_more_replies => announcement.replies.count > 2 ? announcement.replies.count - 2 : nil,
            :replies => announcement.replies.take(2).map do |reply| 
              { :user_avatar_url => url(reply.user.avatar_url(:thumb)),
                :posted_by => reply.user.name,
                :body => reply.body,
                :posted_at => reply.created_at.strftime("%I:%M%P %b %d")
              }
            end
          }
        end
      }
    end
  end

  

end
