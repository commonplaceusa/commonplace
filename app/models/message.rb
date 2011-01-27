class Message < ActiveRecord::Base
  include IDEncoder
  
  belongs_to :user
  belongs_to :recipient, :class_name => "User"
  validates_presence_of :subject, :body
  
  def long_id
    IDEncoder.from_long_id(self.id)
  end
  
  def self.find_by_long_id(long_id)
    Message.find(IDEncoder.from_long_id(long_id))
  end
  
end
