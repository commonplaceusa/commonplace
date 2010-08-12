class Message < ActiveRecord::Base
  belongs_to :user
  belongs_to :conversation
  accepts_nested_attributes_for :conversation
end
