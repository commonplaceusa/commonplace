class Message < ActiveRecord::Base
  belongs_to :user
  belongs_to :recipient, :class_name => "User"
  validates_presence_of :subject, :body
  
end
