class SendNewUsers
  @queue = :statistics
  def self.perform
    Resque.enqueue(NewUsers)
  end
end
