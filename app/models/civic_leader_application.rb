class CivicLeaderApplication < ActiveRecord::Base
  attr_accessible :email, :name, :reason
end
