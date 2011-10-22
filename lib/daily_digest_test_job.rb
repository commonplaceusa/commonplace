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
    Resque.redis.rpush("daily_digest_test_results", "#{sent.count}")
  end
end
