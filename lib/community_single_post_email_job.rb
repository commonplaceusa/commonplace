class CommunitySinglePostEmailJob
  include MailUrls
  @queue = :community_single_post_email

  def self.url(path)
    if path.start_with?("http")
      path
    else
      if Rails.env.development?
        "http://localhost:5000" + path
      else
        "https://www.ourcommonplace.com" + path
      end
    end
  end

  def self.asset_url(path)
    if path.start_with?("http")
      path
    else
      "https://s3.amazonaws.com/commonplace-mail-assets-production/#{path}"
    end
  end

  def self.community_url(community, path)
    CommunitySinglePostEmailJob.url("/#{community.slug}#{path}")
  end

  def self.show_announcement_url(community, id)
    CommunitySinglePostEmailJob.community_url(community, "/show/announcements/#{id}")
  end

  def self.show_post_url(community, id)
    CommunitySinglePostEmailJob.community_url(community, "/show/posts/#{id}")
  end

  def self.show_event_url(community, id)
    CommunitySinglePostEmailJob.community_url(community, "/show/events/#{id}")
  end

  def self.message_user_url(community, id)
    CommunitySinglePostEmailJob.community_url(community, "/message/users/#{id}")
  end

  def self.perform(community_id, time_start, time_end)
    kickoff = KickOff.new
    community = Community.find(community_id)

    start_date = DateTime.parse(time_start)
    end_date = DateTime.parse(time_end)

    posts = community.posts.between(start_date, end_date).map do |post|
      Serializer::serialize(post).tap do |post|
        post['replies'].each do |reply|
          reply['published_at'] = reply['published_at'].strftime("%l:%M%P")
          reply['avatar_url'] = CommunitySinglePostEmailJob.asset_url(reply['avatar_url'])
        end
        post['avatar_url'] = CommunitySinglePostEmailJob.asset_url(post['avatar_url'])
        post['url'] = CommunitySinglePostEmailJob.show_post_url(community, post['id'])
        post['new_message_url'] = CommunitySinglePostEmailJob.message_user_url(community, post['user_id'])
      end
    end

    community.users.receives_posts_live_limited.each do |user|
      begin
        kickoff.deliver_single_post_email(user.id, posts.sample)
      rescue
      end
    end
  end

end
