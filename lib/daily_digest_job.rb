class DailyDigestJob
  @queue = :daily_digest

  def self.perform
    date = DateTime.now.utc.to_s(:db)

    Community.all.each do |community|
      begin
        Resque.enqueue(CommunityDailyBulletinJob, community.id, date)
      rescue
      end
    end
  end

end
