class SafetyAnnouncementJob
  @queue = :safety_announcement

  @community_ids = [2, 8, 9, 26, 28, 30, 34]

  def self.perform

    Community.all.each do |community|
      begin
        if @community_ids.include?(community.id)
          Resque.enqueue(CommunitySafetyAnnouncementJob, community.id)
        end
      rescue
      end
    end
  end

end
