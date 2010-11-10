require 'smtp_api_header.rb'

class NotificationsMailer < ActionMailer::Base

  @queue = :notifications_mailer
  RECIPIENT = "sengrid@example.com"
  def self.perform(notified_type, notifiable_type, 
                   notified_id, notifiable_id)
    
    notified = notified_type.constantize.find(notified_id.to_i)
    notifiable = notifiable_type.constantize.find(notifiable_id.to_i)
    method = [notified_type, notifiable_type].join("_").downcase
    self.send("deliver_#{method}", notified, notifiable)
  end

  
  def neighborhood_post(neighborhood, post)
    recipients RECIPIENT
    users = neighborhood.users.reject{|u| u == post.user}.select(&:receive_posts)
    header = SmtpApiHeader.new
    header.addTo(users.map(&:email))
    header.addSubVal('<name>', users.map(&:name))
    @headers['X-SMTPAPI'] = header.asJSON
    subject "#{post.user.full_name} posted a/an #{post.category} to your neighborhood"
    from "neighborhood-posts@commonplaceusa.com"
    body :post => post
  end

  def feed_event(feed, event)
    recipients RECIPIENT
    users = feed.subscribers
    header = SmtpApiHeader.new
    header.addTo(users.map(&:email))
    header.addSubVal('<name>', users.map(&:name))
    @headers['X-SMTPAPI'] = header.asJSON
    users feed.subscribers.map(&:email)
    subject "#{feed.name} posted a new event"
    from "events@commonplaceusa.com"
    body :feed => feed, :event => event
  end

  def feed_announcement(feed, announcement)
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
