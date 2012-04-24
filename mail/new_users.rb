class NewUsers < MailBase
  
  def initialize
    @day = DateTime.now
    @community = Community.find_by_slug("Belmont")
  end

  def subject
    "belmont users"
  end

  def to
    "julia@commonplaceusa.com"
  end

  def users
    @community.users.where("? < created_at AND created_at < ?", 
      @day.beginning_of_day,
      @day.end_of_day).to_a
  end

  def day
   @day.to_s(:db)
  end

  def from
    "postmaster@ourcommonplace.com"
  end

  def deliver?
    true
  end

  def tag
    'stats'
  end
end
