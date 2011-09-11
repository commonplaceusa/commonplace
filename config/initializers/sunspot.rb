
if Rails.env.development? || Rails.env.test?
  Sunspot.session = Sunspot::SessionProxy::SilentFailSessionProxy.new(Sunspot.session)
end



