class Reply < ActiveRecord::Base
  #track_on_creation
  
  belongs_to :repliable, :polymorphic => true, :touch => true
  belongs_to :user
  
  validates_presence_of :repliable
  validates_presence_of :user
  validates_presence_of :body

  scope :between, lambda { |start_date, end_date| { :conditions => ["? <= created_at AND created_at < ?", start_date.utc, end_date.utc] } }


end
