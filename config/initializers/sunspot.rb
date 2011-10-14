
if Rails.env.development? || Rails.env.test?
  #Sunspot.session = Sunspot::SessionProxy::SilentFailSessionProxy.new(Sunspot.session)
end

Sunspot.config.pagination.default_per_page = 25

