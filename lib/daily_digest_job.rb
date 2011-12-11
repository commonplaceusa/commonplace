class DailyDigestJob
  @queue = :daily_digest
  extend HerokuResqueAutoScale

  def self.perform
    date = DateTime.now.utc.to_s(:db)

    Community.all.each do |community|
      Exceptional.rescue do
        Resque.enqueue(CommunityDailyBulletinJob, community.id, date)
      end
    end
  end

end
