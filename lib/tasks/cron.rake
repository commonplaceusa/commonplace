desc "This task is called by the Heroku cron add-on"
task :cron => :environment do
  if Time.now.hour == 0 # run at midnight

    # Reset the number of e-mails that have been sent to a user
    ActiveRecord::Base.establish_connection
    ActiveRecord::Base.connection.execute("UPDATE users SET emails_sent = 0 WHERE 1=1")
  end
end
