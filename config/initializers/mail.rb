$MailDeliveryMethod = ENV['mail_delivery_method'].try(:intern) || :file

$MailDeliveryOptions = 
  if $MailDeliveryMethod == :file
    {:location => Rails.root.join('tmp','inboxes')}
  else
    { 
    :address => ENV['mail_address'],
    :port => ENV['mail_port'],
    :domain => ENV['domain'],
    :authentication => ENV['mail_authentication'],
    :user_name => ENV['mail_username'],
    :password => ENV['mail_password'] 
    } 
  end
