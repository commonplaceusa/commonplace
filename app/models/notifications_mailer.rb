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
  
  def neighborhood_post(post_id)
    recipients RECIPIENT
    @post = Post.find(post_id)
    @neighborhood = @post.neighborhood
    @community = @neighborhood.community
    users = @neighborhood.users.reject{|u| u == @post.user}.select(&:receive_posts)
    header = SmtpApiHeader.new
    header.addTo(users.map(&:email))
    header.addSubVal('<name>', users.map(&:name))
    @headers['X-SMTPAPI'] = header.asJSON
    subject "#{@post.user.full_name} just posted a message to your neighborhood"
    from "CommonPlace <#{@post.long_id}@replies.commonplaceusa.com>"
  end
  
  def user_message(messengee_id, messenger_id, message_subject, message)
    @messengee = User.find(messengee_id)
    @messenger = User.find(messenger_id)
    @community = @messenger.community
    recipients @messengee.email
    from "CommonPlace <messages@commonplaceusa.com>"
    subject "#{@messenger.name} just sent you a message on CommonPlace"
    body :message_subject => message, :message => message
  end

  def feed_message(feed_id, user_id, message_subject, message)
    @feed = Feed.find(feed_id)
    @user = User.find(user_id)
    @community = @user.community
    recipients @feed.user.email
    from "CommonPlace <messages@commonplaceusa.com>"
    subject "#{@user.name} just sent #{@feed.name} a message on CommonPlace"
    body :message_subject => message_subject, :message => message
  end

  def event_message(event_id, user_id, message_subject, message)
    @event = Event.find(event_id)
    @user = User.find(user_id)
    @community = @user.community
    recipients @event.user.email
    from "CommonPlace <messages@commonplaceusa.com>"
    subject "#{@user.name} just sent #{@event.name} a message on CommonPlace"
    body :message_subject => message_subject, :message => message
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
    from "CommonPlace <#{@post.long_id}@replies.commonplaceusa.com>"
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
    from "CommonPlace <events@replies.commonplaceusa.com>"
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
    from "CommonPlace <announcements@replies.commonplaceusa.com>"
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
    from "announcements@commonplaceusa.com"
    body :feed => feed, :announcement => announcement
  end
end
