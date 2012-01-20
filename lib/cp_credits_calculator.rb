class CpCreditsCalculator
  @queue = :credits
  extend HerokuResqueAutoScale

  def self.perform
    User.where("cp_credits_are_valid = false").each do |user|
      user.calculated_cp_credits = user.all_cpcredits
      user.save
    end
  end
end
