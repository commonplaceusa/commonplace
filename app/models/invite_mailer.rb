class InviteMailer < ActionMailer::Base
  include Resque::Mailer
  
  def user_invite(user_id, email, message)
    @user = User.find(user_id)
    @community = @user.community
    recipients email
    from "invites@commonplaceusa.com"
    subject "#{@user.name} invited you to join #{@community.name} CommonPlace"
  end

  def feed_invite(feed_id, email)
    @feed = Feed.find(feed_id)
    @community = @feed.community
    recipients email
    from "invites@commonplaceusa.com"
    subject "#{@feed.name} invited you to join #{@community.name} CommonPlace"
  end

end
