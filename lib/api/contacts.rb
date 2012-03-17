class API
  class Contacts < Unauthorized
    get "/get/:oauth_verifier" do |oauth_verifier|
      provider = session[:email_contact_provider]
      consumer = ::Contacts.deserialize_consumer(provider, session[:email_contact_consumer])
      consumer.authorize({ 'oauth_verifier' => oauth_verifier })
      if consumer.contacts.present?
        serialize consumer.contacts
      else
        halt [400, "could not authenticate"]
      end
    end

    post "/authorization_url/:provider" do |provider|
      PROVIDER_TYPES = ["yahoo"]
      unless PROVIDER_TYPES.include? provider
        halt [401, "unallowed provider"]
      end
      return_url = request_body['return_url']
      consumer = case provider
                 when 'yahoo'
                   ::Contacts::Yahoo.new
                 end
      authentication_url = consumer.authentication_url(return_url)
      session[:email_contact_consumer] = consumer.serialize
      session[:email_contact_provider] = provider
      serialize authentication_url
    end
  end
end
