class EmailCountResetter
  @queue = :database

  def self.perform
    User.update_all("emails_sent = 0")
  end
end
