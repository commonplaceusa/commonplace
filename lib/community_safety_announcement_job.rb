require 'rubygems'

class CommunitySafetyAnnouncementJob
  extend Resque::Plugins::JobStats
  include MailUrls
  @queue = :community_announcement

  def self.perform(community_id)
    kickoff = KickOff.new
    community = Community.find(community_id)

    community.users.each do |user|
      begin
        parameters = {
          user_id: user.id,
        }
        kickoff.deliver_safety_email(user.id)
      rescue => ex
        Airbrake.notify_or_ignore(
          :error_class   => "Error Sending Safety Announcement",
          :error_message => "Could not send to #{user.email}: #{e.message}",
          :parameters    => parameters
        )
      end
    end
  end
end
