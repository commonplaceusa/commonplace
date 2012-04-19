require 'openssl'
class API

  class Integration < Base

    helpers do 

      # Tells us whether the current_request came from Mailgun
      #
      # See http://documentation.mailgun.net/user_manual.html#securing-webhooks
      def authentic_mailgun?
        return params[:signature] == OpenSSL::HMAC.hexdigest(
          OpenSSL::Digest::Digest.new('sha256'),
          $MailgunAPIToken,
          [params[:timestamp], params[:token]].join)
      end
    end

    # Receive incoming replies from mailgun
    post "/mailgun/posts" do
      logger.debug "Post from Mailgun"
      authentic_mailgun? || (halt 200)
      logger.debug "Authentic"
      begin
        logger.debug "Creating post"
        MailgunPost.new(request_body).save
        logger.debug "Done"
      ensure
        logger.debug "Halting"
        halt 200
      end
    end

    # When a user marks us as spam, Mailgun lets us know, and we don't
    # send them any more emails
    post "/mailgun/disabled_emails" do
      authentic_mailgun? || (halt 200)
      begin
        User.find_by_email(params[:recipient])
          .update_attribute(:post_receive_method, "Never")
      ensure
        halt 200
      end
    end
      
  end
  
end
