class Subscription < ActiveRecord::Base
  attr_accessible :receive_method, :feed_id, :user_id
  belongs_to :user
  belongs_to :feed

  scope :between, lambda { |start_date, end_date| { :conditions => ["? <= subscriptions.created_at AND subscriptions.created_at < ?", start_date.utc, end_date.utc] } }

  def self.receive_methods
    ["Live", "Daily", "Never"]
  end

end
