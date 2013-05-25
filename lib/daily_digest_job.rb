class DailyDigestJob
  @queue = :daily_digest

  def self.perform
    date = DateTime.now.utc.to_s(:db)

    Community.find_each do |community|
      Resque.enqueue(CommunityDailyBulletinJob, community.id, date)
    end
  end

end
