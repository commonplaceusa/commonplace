class EmailCountResetter
  @queue = :database

  def self.perform
    User.update_all("emails_sent = 0")
    # While we're at it, remove all CommonPlace CommonPlace
    # emails from the email tracking
    SentEmail.all(:conditions => {'originating_community_id' => Community.find_by_slug('commonplace').id}).map &:destroy
  end
end
