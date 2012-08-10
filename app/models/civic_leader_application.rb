class CivicLeaderApplication < ActiveRecord::Base
  attr_accessible :email, :name, :reason, :community_id
end
