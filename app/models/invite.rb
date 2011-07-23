class Invite < ActiveRecord::Base
  #track_on_creation
  
  belongs_to :invitee, :class_name => "User"
  belongs_to :inviter, :polymorphic => true


end
