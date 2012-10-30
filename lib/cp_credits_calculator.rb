class CpCreditsCalculator
  extend Resque::Plugins::JobStats
  @queue = :credits

  def self.perform
    User.where("cp_credits_are_valid = false").each do |user|
      user.calculated_cp_credits = user.all_cpcredits
      user.cp_credits_are_valid = true
      user.save
    end
  end
end
