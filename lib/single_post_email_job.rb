class SinglePostEmailJob
  @queue = :single_post_email

  def self.perform
    now = DateTime.now.utc
    end_date = now.to_s(:db)
    start_date = now.ago(5*60*60).to_s(:db)  # go back 5 hours

    Community.all.each do |community|
      begin
        Resque.enqueue(CommunitySinglePostEmailJob, community.id, start_date, end_date)
      rescue
      end
    end
  end

end
