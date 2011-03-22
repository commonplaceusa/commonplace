class DailyDigestJob
  
  @queue = :daily_digest

  def self.perform
    User.receives_daily_digest.each do |user|
      Resque.enqueue(DailyBulletin, user.di, Date.today)
    end
  end

end
