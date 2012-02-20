class EmailTracker

  EMAIL_TRACKING_BASE_URL = 'http://commonplace-emails.heroku.com/api/email'
  API = RestClient::Resource.new "#{EMAIL_TRACKING_BASE_URL}/create"

  def self.new_email(params)
    if Rails.env.production?
      response = API.put params.to_json, :content_type => :json
    else
      response = "-1"
    end
    response
  end

  def self.create_with_tracking_pixel(params)
    sent_email_id = EmailTracker.new_email(params)
    "<img src='#{EMAIL_TRACKING_BASE_URL}/opened/#{sent_email_id}' width='1px' height='1px' />"
  end

end
