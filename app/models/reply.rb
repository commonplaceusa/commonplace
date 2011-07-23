class Reply < ActiveRecord::Base
  #track_on_creation
  
  belongs_to :repliable, :polymorphic => true, :touch => true
  belongs_to :user
  
  validates_presence_of :repliable
  validates_presence_of :user
  validates_presence_of :body


end
