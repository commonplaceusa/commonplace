class DailyDigestJob
  
  @queue = :daily_digest

  def self.perform
    User.receives_daily_digest.each do |user|
      Resque.enqueue(DailyBulletin, user.id, DateTime.now.utc.to_s(:db))
    end
  end

end
