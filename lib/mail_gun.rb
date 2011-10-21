class MailGun

  def self.deliver(method, options, to, from, reply_to, subject, content_type = "text/html", body, charset = "UTF-8", headers = {})
    if (method == :file)
      # Save the e-mail to a file
      # STUB
    else if (method == :action_mailer)
      # Send the e-mail with actionmailer
      Mail.defaults do
        delivery_method(method, options)
      end
      Mail.deliver(:to => to,
                   :from => from,
                   :reply_to => reply_to,
                   :subject => subject,
                   :content_type => content_type,
                   :body => body,
                   :charset => charset,
                   :headers => headers)
    else
      # Deliver with Mailgun
      response = RestClient.post "https://api:#{options[:api_key]}@api.mailgun.net/v2/#{options[:domain]}/messages", :from => from, :to => to, :subject => subject, :html => body, :tag => ((headers['X-Milgun-Tag'].present?) ? headers['X-Mailgun-Tag']: ""), "h:X-Reply-To" => reply_to, "h:X-Precedence", "h:Auto-Submitted" => ((headers["Auto-Submitted"].present?) ? headers["Auto-Submitted"] : ""), "h:Return-Path" => ((headers["Return-Path"].present?) ? headers["Return-Path"] : ""), "h:X-Campaign-ID" => ((headers["X-Campaign-Id"].present?) ? headers["X-Campaign-Id"] : "")
      # Do something with the response...
      Resque.redis.rpush("api_results", response.to_str)
    end
  end

end
