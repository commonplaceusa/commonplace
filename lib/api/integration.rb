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
      authentic_mailgun? || (halt 401)
      begin
        MailgunPost.new(params).save
      rescue
        halt 501
      end
      200
    end

    # When a user marks us as spam, Mailgun lets us know, and we don't
    # send them any more emails
    post "/mailgun/disabled_emails" do
      authentic_mailgun? || (halt 401)
      begin
        User.find_by_email(params[:recipient])
          .update_attribute(:post_receive_method, "Never")
      rescue
        halt 501
      end
      200
    end
      
  end
  
end
