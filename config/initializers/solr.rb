if Rails.env.development? or CP_ENV == 'staging'
  Sunspot::Rails::Server.new.start
end
