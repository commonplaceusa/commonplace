class Referral < ActiveRecord::Base
  belongs_to :referrer, :class_name => "User"
  belongs_to :referee, :class_name => "User"
  belongs_to :event

end
