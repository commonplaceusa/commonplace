class StatisticsUserCountCsvGenerator
  def self.perform!
    csv = "Date,"
    communities = Community.order("id ASC").map { |c| c.slug }.reject { |c| GeckoBoardAnnouncer::EXCLUDED_COMMUNITIES.include? c }
    csv << communities.join(",")
    start_date = Date.parse("1-1-2010").to_datetime
    start_date.upto(Date.today - 1.day) do |date|
      csv << "\n#{date.to_s(:mdy).split("T").first}"
      communities.each do |community_slug|
        csv << ",#{Community.find_by_slug(community_slug).users.up_to(date.to_datetime).count.to_s}"
      end
    end
    Resque.redis.set("statistics:user_counts", csv)
  end
end
