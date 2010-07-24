class Community < ActiveRecord::Base
  has_many :users
end
