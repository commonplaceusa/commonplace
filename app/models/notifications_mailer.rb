require 'smtp_api_header.rb'

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
    puts @post.inspect
    puts @community.inspect
    users = @neighborhood.users.reject{|u| u == @post.user}.select(&:receive_posts)
    header = SmtpApiHeader.new
    header.addTo(users.map(&:email))
    header.addSubVal('<name>', users.map(&:name))
    @headers['X-SMTPAPI'] = header.asJSON
    subject "#{@post.user.full_name} just posted a message to your neighborhood"
    from "CommonPlace <#{@post.long_id}@posts.#{@community.slug}.commonplaceusa.com>"
  end
  
  def message(message_id)
    @message = Message.find(message_id)
    @user = @message.messagable.is_a?(User) ? @message.messagable : @message.messagable.user
    @community = @message.user.community
    recipients @user.email
    from "CommonPlace <#{@message.long_id}@messages.#{@community.slug}.commonplaceusa.com>"
    subject "#{@message.user.name} just sent you a message on CommonPlace"
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
    from "CommonPlace <#{@post.long_id}@replies.commonplaceusa.com>"
    subject "#{@reply.user.name} just replied to a post on CommonPlace"
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
    from "CommonPlace <#{@post.long_id}@messages.#{@community.slug}.commonplaceusa.com>"
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
    from "CommonPlace <#{@event.long_id}@events.#{@community.slug}.commonplaceusa.com>"
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
    from "CommonPlace <#{@announcement.long_id}@announcements.#{@community.slug}.commonplaceusa.com>"
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
    from "CommonPlace <#{@announcement.long_id}@announcements.#{@community.slug}.commonplaceusa.com>"
    body :feed => feed, :announcement => announcement
  end
end
