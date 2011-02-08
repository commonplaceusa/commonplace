class Reply < ActiveRecord::Base
  
  belongs_to :repliable, :polymorphic => true, :touch => true
  belongs_to :user
  
  validates_presence_of :repliable
  validates_presence_of :user
  validates_presence_of :body


end
