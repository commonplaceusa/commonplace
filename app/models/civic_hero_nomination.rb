class CivicHeroNomination < ActiveRecord::Base
  attr_accessible :nominator_email, :nominator_name, :nominee_email, :nominee_name, :reason
end
