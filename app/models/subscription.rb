class Subscription < ActiveRecord::Base
  attr_accessible :receive_method
  belongs_to :user
  belongs_to :feed

  def self.receive_methods
    ["Live", "Daily", "Never"]
  end

end
