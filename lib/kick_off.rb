class KickOff

  def initialize(queuer = Resque)
    @queuer = queuer
  end

  def deliver_post(post)
    return
  end


  def deliver_announcement(post)
    return
  end

  def deliver_reply(reply)
    # We're delivering a reply to the author of the repliable
    repliable_ids = [reply.repliable.user_id]

    # As well as anyone else who replied
    repliable_ids += reply.repliable.replies.map &:user_id

    # But not the author of the current reply
    repliable_ids.delete(reply.user_id)

    # Only send once to each person
    repliable_ids.uniq!

    # Send it
    repliable_ids.each do |user_id|
      enqueue(ReplyNotification, reply.id, user_id)
    end
  end


  def deliver_feed_invite(emails, feed)
    return
  end

  def deliver_n_feed_subscribers_notification(feed_id)
    return
  end

  def deliver_feed_subscription_notification(user_id, feed_id)
    return
  end

  def deliver_met_notification(user_id, current_user_id)
    return
  end

  def deliver_group_post(post)
    return
  end


  def deliver_user_message(message)
    enqueue(MessageNotification, message.id, message.messagable_id)
  end


  def deliver_post_to_community(post)
    return
  end

  def deliver_user_invite(emails, from_user, message = nil)
    return
  end

  # Sends an invite to a resident, from the given user
  #
  # Params:
  #   resident
  #   user
  def deliver_invite_to_resident(resident, user)
    return
  end

  def deliver_post_confirmation(post)
    return
  end


  def deliver_announcement_confirmation(post)
    return
  end


  def deliver_feed_permission_warning(user, feed)
    return
  end


  def deliver_unknown_address_warning(user)
    return
  end


  def deliver_unknown_user_warning(email)
    return
  end


  def deliver_welcome_email(user)
    return
  end

  def deliver_safety_email(user_id)
    return
  end

  def deliver_password_reset(user)
    enqueue(PasswordReset, user.id)
  end


  def deliver_admin_question(from_email, message, name)
    return
  end


  def deliver_daily_bulletin(user_id, date_string, posts, group_posts, transactions, announcements, events, weather)
    enqueue(DailyBulletin, user_id, date_string, posts, group_posts, transactions, announcements, events, weather)
  end

  def deliver_single_post_email(user_id, post)
    return
  end

  def deliver_feed_owner_welcome(feed)
    return
  end

  def deliver_thank_notification(thank)
    return
  end

  def deliver_flag_notification(flag)
    return
  end

  def deliver_flag_notification(flag_id)
    return
  end

  def deliver_share_notification(user, item, recipient_email)
    enqueue(ShareNotification, user, item, recipient_email)
  end

  def deliver_email_share(recipients, postlike_id, postlike_type, community_id, current_user_id)
    enqueue(EmailShare, recipients, postlike_id, postlike_type, community_id, current_user_id)
  end

  def deliver_statistics_ready_notification(admin_user)
    return
  end

  def send_spam_report_received_notification(user)
    return
  end

  def deliver_network_health_stats_document(filename, interval)
    return
  end

  def enqueue_statistics_generation_job(stats_type, account = nil)
    return
  end

  def enqueue_statistic_increment(key)
    return
  end

  private

  def enqueue(*args)
    @queuer.enqueue(*args)
  end

  def send_post_to_neighborhood(post, neighborhood)
  end
end
