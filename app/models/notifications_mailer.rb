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
    users = neighborhood.users.reject{|u| u == post.user}
    header = SmtpApiHeader.new
    header.addTo(users.map(&:email))
    header.addSubVal('<name>', users.map(&:name))
    @headers['X-SMTPAPI'] = header.asJSON
    subject "#{post.user.full_name} posted a/an #{post.category} to your neighborhood"
    from "neighborhood-posts@commonplaceusa.com"
    body :post => post
  end

  def organization_event(organization, event)
    recipients RECIPIENT
    users = organization.subscribers
    header = SmtpApiHeader.new
    header.addTo(users.map(&:email))
    header.addSubVal('<name>', users.map(&:name))
    @headers['X-SMTPAPI'] = header.asJSON
    users organization.subscribers.map(&:email)
    subject "#{organization.name} posted a new event"
    from "events@commonplaceusa.com"
    body :organization => organization, :event => event
  end

  def organization_announcement(organization, announcement)
    recipients RECIPIENT
    users = organization.subscribers
    header = SmtpApiHeader.new
    header.addTo(users.map(&:email))
    header.addSubVal('<name>', users.map(&:name))
    @headers['X-SMTPAPI'] = header.asJSON
    subject "#{organization.name} posted a new announcement"
    from "announcements@commonplaceusa.com"
    body :organization => organization, :announcement => announcement
  end
end
