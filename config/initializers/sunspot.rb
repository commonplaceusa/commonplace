
if Rails.env.development?
  Sunspot.session = Sunspot::SessionProxy::SilentFailSessionProxy.new(Sunspot.session)
end



