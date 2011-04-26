class Membership < ActiveRecord::Base

  def self.receive_methods
    ["Live", "Daily", "Never"]
  end

  validates_presence_of :user, :group
  attr_accessible :receive_method
  belongs_to :user
  belongs_to :group

end
