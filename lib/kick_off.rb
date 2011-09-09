class KickOff
  
  def initialize(resque = Resque)
    @resque = resque
  end
 
  def deliver_post(post)
    # We're sending a post to a neighborhood
    neighborhood = post.user.neighborhood

    # Which means the people in the neighborhood
    # Who receive posts live
    recipient_ids = neighborhood.users.receives_posts_live.map(&:id)

    # Who are not the poster
    recipient_ids.delete(post.user.id)

    # Send it
    recipient_ids.each do |user_id|
      enqueue(PostNotification, post.id, user_id)
    end
  end


  def deliver_announcement(post)
    # We're only actually delivering anything if the poster is a feed
    return if !post.owner.is_a? Feed

    # We're delivering to live subscribers of the feed
    recipient_ids = post.owner.live_subscribers.map &:id

    # Send it
    recipient_ids.each do |user_id|
       enqueue(AnnouncementNotification, post.id, user_id)
    end
  end

  
  def deliver_reply(reply)
    # We're delivering a reply to the author of the repliable
    repliable_ids = [reply.repliable.user_id]

    # As well as anyone else who replied
    repliable_ids += reply.repliable.replies.map &:user_id
    
    # But not the author of the current reply
    repliable_ids.delete(reply.user_id)

    # Send it
    repliable_ids.each do |user_id|
      enqueue(ReplyNotification, reply.id, user_id)
    end
  end

  
  def deliver_feed_invite(emails, feed)
    # Given some emails 
    recipients = Array(emails) # it's definitely an array now

    # That don't already exist in the system
    recipients.reject! {|email| User.exists?(:email => email) }

    # Send invites
    recipients.each do |email|
      enqueue(FeedInvitation, email, feed.id)
    end
  end

  
  def deliver_group_post(post)
    # We're delivering a post to subscribers of the group
    recipients = post.group.live_subscribers.map(&:id)

    # Who aren't the poster
    recipients.delete(post.user_id)

    # Send it
    recipients.each do |user_id|
      enqueue(GroupPostNotification, post.id, user_id)
    end
  end

  
  def deliver_user_message(message)
    enqueue(MessageNotification, message.id, message.messagable_id)
  end

  private
  
  def enqueue(*args)
    @resque.enqueue(*args)
  end
  
end
