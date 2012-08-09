class Invite < ActiveRecord::Base
  #track_on_creation

  belongs_to :invitee, :class_name => "User"
  belongs_to :inviter, :polymorphic => true,:counter_cache => true

  scope :today, :conditions => ["invites.created_at between ? and ?", DateTime.now.at_beginning_of_day, Time.now]
  scope :this_week, :conditions => ["invites.created_at between ? and ?", DateTime.now.at_beginning_of_week, Time.now]

  after_create :update_user_invite_count

  def update_user_invite_count
    @user=User.find(inviter_id)
    @user.update_attribute(:invite_count, @user.invite_count+1)
  end
end
