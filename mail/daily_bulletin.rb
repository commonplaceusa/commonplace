class DailyBulletin < MailBase

  def initialize(user_id, date)
    @user, @date = User.find(user_id), Date.parse(date)
  end

  def beginning_of_day
    @date.beginning_of_day
  end

  def end_of_day
    @date.end_of_day
  end

  def user 
    @user
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
    community.posts.between(Time.now.advance(:days => -1), Time.now).map do |post|
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

end
