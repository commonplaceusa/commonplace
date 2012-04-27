class SendNewUsers
  @queue = :statistics
  def self.perform
    Resque.enqueue(NewUsers, DateTime.now.utc.to_s(:db))
  end
end
