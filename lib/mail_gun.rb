class MailGun

  def self.deliver(method, options, to, from, reply_to, subject, body, content_type = "text/html", charset = "UTF-8", headers = {}, fake = false)
    if (method == :file)
      # STUB
      return
    elsif (method == :action_mailer)
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
      params = {}
      params[:to] = to
      params[:from] = from
      params[:subject] = subject
      params[:html] = body
      if headers['X-Mailgun-Tag']
        params[:tag] = headers['X-Mailgun-Tag']
        headers.delete('X-Mailgun-Tag')
      else
        params[:tag] = ''
      end
      params["h:X-Reply-To"] = reply_to
      headers.each do |k,v|
        params["h:#{k}"] = v
      end

      endpoint = "https://api:#{options[:api_key]}@api.mailgun.net/v2/#{options[:domain]}/messages"
      if fake
        puts "Sending e-mail to endpoint #{endpoint} with parameters #{params.inspect}"
      else
        response = RestClient.post endpoint, {:params => params}
        # Do something with the response...
        Resque.redis.rpush("api_results", response.to_str)
      end
    end
  end

end
