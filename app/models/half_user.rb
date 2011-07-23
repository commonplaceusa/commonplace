class HalfUser < ActiveRecord::Base
  #track_on_creation

  belongs_to :community
  validates_presence_of :email

  def full_name
    [first_name, middle_name, last_name].select(&:present?).join(" ")
  end

  def full_name=(string)
    split_name = string.to_s.split(" ")
    self.first_name = split_name.shift.to_s.capitalize
    self.last_name = split_name.pop.to_s.capitalize
    self.middle_name = split_name.map(&:capitalize).join(" ")
    self.full_name
  end
end
