class NotificationsMailer < ActionMailer::Base
  helper :text
  helper_method :url
  include TextHelper

  include Resque::Mailer
  @queue = :notifications

  def url(path = "")
    "http://" + @community.slug + ".ourcommonplace.com" + path
  end

  RECIPIENT = "sengrid@example.com"
  
  def neighborhood_post(neighborhood_id, post_id)
    recipients RECIPIENT
    @post = Post.find(post_id)
    @neighborhood = Neighborhood.find(neighborhood_id)
    @community = @neighborhood.community
    users = @neighborhood.users.receive_posts_live.reject{|u| u == @post.user}
    header = SmtpApiHeader.new
    header.addTo(users.map(&:email))
    header.addSubVal('<name>', users.map(&:name))
    @headers['X-SMTPAPI'] = header.asJSON
    @headers['Reply-To'] = "CommonPlace <#{@post.long_id}@posts.#{@community.slug}.ourcommonplace.com>"
    headers 'X-SMTPAPI' => @headers['X-SMTPAPI'],
            "Reply-To" => @headers['Reply-To']
    subject "#{@post.user.full_name} just posted a message to your neighborhood"
    from "#{@community.name} CommonPlace <notifications@#{@community.slug}.ourcommonplace.com>"
  end
  
  def neighborhood_post_confirmation(neighborhood_id, post_id)
    recipients RECIPIENT
    @post = Post.find(post_id)
    @neighborhood = Neighborhood.find(neighborhood_id)
    @community = @neighborhood.community
    users = [@post.user]
    header = SmtpApiHeader.new
    header.addTo(users.map(&:email))
    header.addSubVal('<name>', users.map(&:name))
    @headers['X-SMTPAPI'] = header.asJSON
    @headers['Reply-To'] = "CommonPlace <#{@post.long_id}@posts.#{@community.slug}.ourcommonplace.com>"
    headers 'X-SMTPAPI' => @headers['X-SMTPAPI'],
            "Reply-To" => @headers['Reply-To']
    subject "You just e-mailed a message to your neighborhood"
    from "#{@community.name} CommonPlace <notifications@#{@community.slug}.ourcommonplace.com>"
  end
  
  def feed_announcement_confirmation(feed_id, announcement_id)
    recipients RECIPIENT
    @pannouncement = Announcement.find(announcement_id)
    @feed = Feed.find(feed_id)
    @community = @feed.community
    users = [@post.user]
    header = SmtpApiHeader.new
    header.addTo(users.map(&:email))
    header.addSubVal('<name>', users.map(&:name))
    @headers['X-SMTPAPI'] = header.asJSON
    @headers['Reply-To'] = "CommonPlace <#{@announcement.long_id}@posts.#{@community.slug}.ourcommonplace.com>"
    headers 'X-SMTPAPI' => @headers['X-SMTPAPI'],
            "Reply-To" => @headers['Reply-To']
    subject "You just e-mailed an announcement to your feed"
    from "#{@community.name} CommonPlace <notifications@#{@community.slug}.ourcommonplace.com>"
  end
  
  def feed_announcement_failure(feed_id, community_id)
    @announcement = Feed.find(feed_id)
    @community = Community.find(community_id)
    recipients RECIPIENT
    users = [@feed.owner]
    header = SmtpApiHeader.new
    header.addTo(users.map(&:email))
    header.addSubVal('<name>', users.map(&:name))
    @headers['X-SMTPAPI'] = header.asJSON
    @headers['Reply-To'] = "CommonPlace <notifications@#{@community.slug}.ourcommonplace.com>"
    headers 'X-SMTPAPI' => @headers['X-SMTPAPI'],
            "Reply-To" => @headers['Reply-To']
    subject "Failed to Post Message"
    from "#{@community.name} CommonPlace <notifications@#{@community.slug}.ourcommonplace.com>"
  end
  
  def neighborhood_post_failure(user_id, community_id)
    @aser = User.find(user_id)
    @community = Community.find(community_id)
    recipients RECIPIENT
    users = [@user]
    header = SmtpApiHeader.new
    header.addTo(users.map(&:email))
    header.addSubVal('<name>', users.map(&:name))
    @headers['X-SMTPAPI'] = header.asJSON
    @headers['Reply-To'] = "CommonPlace <notifications@#{@community.slug}.ourcommonplace.com>"
    headers 'X-SMTPAPI' => @headers['X-SMTPAPI'],
            "Reply-To" => @headers['Reply-To']
    subject "Failed to Post Message"
    from "#{@community.name} CommonPlace <notifications@#{@community.slug}.ourcommonplace.com>"
  end  
  
  def unpublished_posts_report
    recipients RECIPIENT
    users = [@user]
    header = SmtpApiHeader.new
    header.addTo(users.map(&:email))
    header.addSubVal('<name>', users.map(&:name))
    @headers['X-SMTPAPI'] = header.asJSON
    @headers['Reply-To'] = "CommonPlace <notifications@#{@community.slug}.ourcommonplace.com>"
    headers 'X-SMTPAPI' => @headers['X-SMTPAPI'],
            "Reply-To" => @headers['Reply-To']
    subject "Unpublished Posts"
    from "#{@community.name} CommonPlace <notifications@#{@community.slug}.ourcommonplace.com>"
  end
    
  
  def message(message_id)
    @message = Message.find(message_id)
    @user = @message.messagable.is_a?(User) ? @message.messagable : @message.messagable.user
    @community = @message.user.community
    headers "Reply-To" => "CommonPlace <#{@message.long_id}@messages.#{@community.slug}.ourcommonplace.com>"
    recipients @user.email
    from "#{@community.name} CommonPlace <notifications@#{@community.slug}.ourcommonplace.com>"
    subject "#{@message.user.name} just sent you a message on CommonPlace"
  end

  def message_reply(reply_id)
    @reply = Reply.find(reply_id)
    @message = @reply.repliable
    @community = @message.user.community
    @recipient = if @message.user == @reply.user
                   @message.messagable.is_a?(User) ? @message.messagable : @message.messagable.user
                 else
                   @message.user
                 end
    recipients @recipient.email
    headers "Reply-To" => "CommonPlace <#{@message.long_id}@messages.#{@community.slug}.ourcommonplace.com>"
    from "#{@community.name} CommonPlace <notifications@#{@community.slug}.ourcommonplace.com>"
    subject "#{@reply.user.name} just replied to a message on CommonPlace"
  end

  def post_reply(reply_id)
    @reply = Reply.find(reply_id)
    @post = @reply.repliable
    @community = @post.user.community
    users = (@post.replies.map(&:user) + [@post.user]).uniq.reject {|u| u == @reply.user}
    header = SmtpApiHeader.new
    header.addTo(users.map(&:email))
    header.addSubVal('<name>', users.map(&:name))
    @headers['X-SMTPAPI'] = header.asJSON
    recipients @post.user.email
    headers "Reply-To" => "CommonPlace <#{@post.long_id}@posts.#{@community.slug}.ourcommonplace.com>"
    from "#{@community.name} CommonPlace <notifications@#{@community.slug}.ourcommonplace.com>"
    subject "#{@reply.user.name} just replied to a post on CommonPlace"
  end


  def event_reply(reply_id)
    @reply = Reply.find(reply_id)
    @event = @reply.repliable
    @community = @event.user.community
    users = (@event.replies.map(&:user) + [@event.user]).uniq.reject {|u| u == @reply.user}
    header = SmtpApiHeader.new
    header.addTo(users.map(&:email))
    header.addSubVal('<name>', users.map(&:name))
    @headers['X-SMTPAPI'] = header.asJSON
    recipients @event.user.email
    headers "Reply-To" => "CommonPlace <#{@event.long_id}@events.#{@community.slug}.ourcommonplace.com>"
    from "#{@community.name} CommonPlace <notifications@#{@community.slug}.ourcommonplace.com>"
    subject "#{@reply.user.name} just replied to an event on CommonPlace"
  end

def announcement_reply(reply_id)
    @reply = Reply.find(reply_id)
    @announcement = @reply.repliable
    @community = @announcement.feed.user.community
    users = (@announcement.replies.map(&:user) + [@announcement.feed.user]).uniq.reject {|u| u == @reply.user}
    header = SmtpApiHeader.new
    header.addTo(users.map(&:email))
    header.addSubVal('<name>', users.map(&:name))
    @headers['X-SMTPAPI'] = header.asJSON
    recipients @announcement.feed.user.email
    headers "Reply-To" => "CommonPlace <#{@announcement.long_id}@announcements.#{@community.slug}.ourcommonplace.com>"
    from "#{@community.name} CommonPlace <notifications@#{@community.slug}.ourcommonplace.com>"
    subject "#{@reply.user.name} just replied to an announcement on CommonPlace"
  end

  def feed_announcement(feed, announcement)
    @community = feed.community
    recipients RECIPIENT
    users = feed.subscribers
    header = SmtpApiHeader.new
    header.addTo(users.map(&:email))
    header.addSubVal('<name>', users.map(&:name))
    @headers['X-SMTPAPI'] = header.asJSON
    subject "#{feed.name} posted a new announcement"
    headers "Reply-To" => "CommonPlace <#{@announcement.long_id}@announcements.#{@community.slug}.ourcommonplace.com>"
    from "#{@community.name} CommonPlace <notifications@#{@community.slug}.ourcommonplace.com>"
    body :feed => feed, :announcement => announcement
  end
end
