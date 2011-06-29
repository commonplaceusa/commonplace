require 'resque/plugins/resque_heroku_autoscaler'

class DailyDigestJob
  extend Resque::Plugins::HerokuAutoscaler
  
  @queue = :daily_digest

  def self.perform
    User.where("post_receive_method != 'Never'").find_each do |user|
      Resque.enqueue(DailyBulletin, user.id, DateTime.now.utc.to_s(:db))
    end
  end

end
