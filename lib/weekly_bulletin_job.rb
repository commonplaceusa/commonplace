class WeeklyBulletinJob

  @queue = :weekly_bulletin

  def self.perform
    User.receives_weekly_bulletin.each do |user|
      Resque.enqueue(WeeklyDigest, user.id, Date.today.beginning_of_day)
    end
  end

end
