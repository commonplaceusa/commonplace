class DailyDigestJob
  @queue = :daily_digest

  def self.perform
    kickoff = KickOff.new
    date = DateTime.now.utc
    User.where("post_receive_method != 'Never'").find_each do |user|
     Exceptional.rescue do
        kickoff.deliver_daily_bulletin(user, date) 
     end
    end
  end

end
