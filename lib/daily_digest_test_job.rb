class DailyDigestTestJob
  @queue = :daily_digest

  def self.perform
    kickoff = KickOff.new
    date = DateTime.now.utc
    sent = []
    User.where("post_receive_method != 'Never'").find_each do |user|
     Exceptional.rescue do
        sent << user
     end
    end
    Resque.redis.set("daily_digest_test_result", "#{sent.count}")
  end
end
