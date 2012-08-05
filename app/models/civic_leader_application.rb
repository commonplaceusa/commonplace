class CivicLeaderApplication < ActiveRecord::Base
  attr_accessible :email, :name, :reason, :community_id

  validates_presence_of :email, :name, :reason, :community_id
end
