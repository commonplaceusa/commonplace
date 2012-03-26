class EmailTracker

  EMAIL_TRACKING_BASE_URL = 'http://www.ourcommonplace.com/api/stats'
  #API = RestClient::Resource.new "#{EMAIL_TRACKING_BASE_URL}/create_email"

  def self.new_email(params)
    sent_email = SentEmail.create!(
        :recipient_email => params['recipient_email'],
        :tag_list => params['tag_list'],
        :status => :sent,
        :originating_community_id => params['originating_community_id'],
        :main_tag => params['tag']
      )
      sent_email.id.to_s
  end

  def self.create_with_tracking_pixel(params)
    sent_email_id = EmailTracker.new_email(params)
    "<img src='#{EMAIL_TRACKING_BASE_URL}/email_opened/#{sent_email_id}' width='1px' height='1px' />"
  end

end
