class SinglePostEmailJob
  @queue = :single_post_email

  def self.perform
    date = DateTime.now.utc.to_s(:db)

    Community.all.each do |community|
      Exceptional.rescue do
        Resque.enqueue(CommunitySinglePostEmailJob, community.id, date)
      end
    end
  end

end
