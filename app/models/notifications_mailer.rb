class NotificationsMailer < ActionMailer::Base
  
  def neighborhood_post(neighborhood, post)
    recipients neighborhood.users.reject{|u| u == post.user}.map(&:email)
    subject "#{post.user.full_name} posted a/an #{post.category} to your neighborhood"
    from "neighborhood-posts@commonplaceusa.com"
    body :post => post
  end

  def organization_event(organization, event)
    recipients organization.subscribers.map(&:email)
    subject "#{organization.name} posted a new event"
    from "events@commonplaceusa.com"
    body :organization => organization, :event => event
  end

  def organization_announcement(organization, announcement)
    recipients organization.subscribers.map(&:email)
    subject "#{organization.name} posted a new announcement"
    from "announcements@commonplaceusa.com"
    body :organization => organization, :announcement => announcement
  end

end
