class Reply < ActiveRecord::Base
  #track_on_creation
  
  belongs_to :repliable, :polymorphic => true
  after_create :touch_repliable_replied_at
  belongs_to :user
  
  validates_presence_of :repliable
  validates_presence_of :user
  validates_presence_of :body

  scope :between, lambda { |start_date, end_date| { :conditions => ["? <= created_at AND created_at < ?", start_date.utc, end_date.utc] } }

  scope :today, :conditions => ["replies.created_at between ? and ?", DateTime.now.at_beginning_of_day, Time.now]

  scope :this_week, :conditions => ["replies.created_at between ? and ?", DateTime.now.at_beginning_of_week, Time.now]

  def touch_repliable_replied_at
    self.repliable.replied_at = Time.zone.now
  end

end
