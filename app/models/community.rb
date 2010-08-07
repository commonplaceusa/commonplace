class Community < ActiveRecord::Base
  has_many :users
  has_many :organizations

  def self.find_by_name(name)
    find(:first, :conditions => ["LOWER(name) = ?", name.downcase])
  end
end
