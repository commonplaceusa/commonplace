class StatisticsTempCsvGenerator
  def self.perform!
    csv = "Town,E-mail,First Name,Last Name\n"
    communities = ["Falls Church", "Marquette", "Chelmsford", "Harrisonburg", "Vienna"]
    communities.each do |c|
      users = Community.find_by_name(c).users.reorder("created_at ASC")
      users.each do |u|
        csv << "#{c},#{u.email},#{u.first_name},#{u.last_name}\n"
      end
    end
    Resque.redis.set("statistics:temp", csv)
  end
end
