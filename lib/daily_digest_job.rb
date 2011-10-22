class DailyDigestJob
  @queue = :daily_digest

  def self.perform
    date = DateTime.now.utc.to_s(:db)

    Community.all.each do |community|
      Exceptional.rescue do
        Resque.enqueue(CommunityDailyBulletinJob, community.id, date)
      end
    end
  end

end
