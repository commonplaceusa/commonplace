class CommunityDailyBulletinJob
  @queue = :community_daily_bulletin

  def self.perform(community_id, date)
    kickoff = KickOff.new
    community = Community.find(community_id)

    community.users.where("post_receive_method != 'Never'").find_each do |user|
      Exceptional.rescue do
        kickoff.deliver_daily_bulletin(user, date) 
      end
    end
  end

end

  
 
