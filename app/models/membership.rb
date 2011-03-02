class Membership < ActiveRecord::Base

  validates_presence_of :user, :group

  belongs_to :user
  belongs_to :group

end
