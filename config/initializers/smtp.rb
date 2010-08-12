CONFIG ||= Rails.root.join("config", "config.yml").open{ |file| YAML::load(file) }
ActionMailer::Base.smtp_settings = {
  :address => "smtp.sendgrid.net",
  :port => '25',
  :domain => "commmonplace.co",
  :authentication => :plain,
  :user_name => CONFIG["sendgrid_user_name"],
  :password => CONFIG["sendgrid_password"]
}
