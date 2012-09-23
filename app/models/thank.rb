class Thank < ActiveRecord::Base
  include Trackable
  after_create :track_posted_content

  belongs_to :user
  belongs_to :thankable, :polymorphic => true

  scope :this_week, :conditions => ["created_at between ? and ?", DateTime.now.at_beginning_of_week, Time.now]

  def replied_at
    self.updated_at
  end

end
