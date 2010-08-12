class Conversation < ActiveRecord::Base
  
  has_many :conversation_memberships
  has_many :users, :through => :conversation_memberships
  has_many :messages

  validates_presence_of :subject
  
end
