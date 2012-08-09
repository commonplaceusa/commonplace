class Invite < ActiveRecord::Base
  #track_on_creation
  
  belongs_to :invitee, :class_name => "User"
  belongs_to :inviter, :polymorphic => true

  scope :today, :conditions => ["invites.created_at between ? and ?", DateTime.now.at_beginning_of_day, Time.now]
  scope :this_week, :conditions => ["invites.created_at between ? and ?", DateTime.now.at_beginning_of_week, Time.now]
end
