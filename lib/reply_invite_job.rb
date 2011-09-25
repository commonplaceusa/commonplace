class ReplyInviteJob
  @queue = :reply_based_invite
   
  def self.perform
    Reply.between(days_ago.days.ago, Time.now).where("repliable_type = ?",repliable_type).map {|reply| Reply.repliable.user_id } do |reply|
      Resque.enqueue(ReplyBasedInvite, user_id)
      end
    end
end
      
