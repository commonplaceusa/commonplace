class DailyDigestJob
  @queue = :daily_digest

  def self.perform
<<<<<<< HEAD
    kickoff = KickOff.new
    date = DateTime.now.utc
    User.where("post_receive_method != 'Never'").find_each do |user|
     Exceptional.rescue do
        kickoff.deliver_daily_bulletin(user, date)
     end
=======
    date = DateTime.now.utc.to_s(:db)

    Community.all.each do |community|
      Exceptional.rescue do
        Resque.enqueue(CommunityDailyBulletinJob, community.id, date)
      end
>>>>>>> 12215272e095bebb55d684f59c2f0096d8889394
    end
  end

end
