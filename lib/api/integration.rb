require 'openssl'
class API

  class Integration < Unauthorized

    helpers do 
      def authentic_mailgun?(token, timestamp, signature)
        return signature == OpenSSL::HMAC.hexdigest(
          OpenSSL::Digest::Digest.new('sha256'),
          $MailgunAPIToken,
          [timestamp, token].join)
      end
    end
    
    before /^\/mailgun/ do
      unless authentic_mailgun?(params[:token], params[:timestamp], params[:signature])
        halt 200
      end
    end
    
    post "/mailgun/posts" do
      begin
        MailgunPost.new(params).save
      ensure
        halt 200
      end
    end
    
    post "/mailgun/disabled_emails" do
      begin
        User.find_by_email(params[:recipient])
          .update_attribute(:post_receive_method, "Never")
      ensure
        halt 200
      end
    end
      
  end
  
end
