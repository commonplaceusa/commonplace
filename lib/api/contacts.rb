class API
  class Contacts < Unauthorized
    get "/retrieve" do
      provider = session[:email_contact_provider]
      consumer = ::Contacts.deserialize_consumer(provider, session[:email_contact_consumer])
      consumer.authorize(params)
      if consumer.contacts.present?
        serialize consumer.contacts
      else
        halt [500, "could not authenticate"]
      end
    end

    post "/authorization_url/:provider" do |provider|
      PROVIDER_TYPES = ["yahoo", "hotmail"]
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
