class CivicHeroNomination < ActiveRecord::Base
  attr_accessible :nominator_email, :nominator_name, :nominee_email, :nominee_name, :reason, :community_id

  validates_presence_of :nominator_email, :nominator_name, :nominee_email, :nominee_name, :reason, :community_id
end
