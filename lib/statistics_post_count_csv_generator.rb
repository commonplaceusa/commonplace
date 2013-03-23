class StatisticsPostCountCsvGenerator
  def self.perform!
    # Resque.redis.set("statistics:post_counts", nil)
    csv = "Date,"
    csv << GeckoBoardAnnouncer::WATCHED_COMMUNITIES.join(",")
    start_date = Date.parse("1-1-2010").to_datetime
    start_date.upto(Date.today - 1.day) do |date|
      csv << "\n#{date.to_s(:mdy).split("T").first}"
      GeckoBoardAnnouncer::WATCHED_COMMUNITIES.each do |community_slug|
        csv << ",#{Community.find_by_slug(community_slug).posts.up_to(date.to_datetime).count.to_s}"
      end
    end
    Resque.redis.set("statistics:post_counts", csv)
  end
end
