class Conversation < ActiveRecord::Base
  
  has_many :conversation_memberships
  has_many :users, :through => :conversation_memberships
  has_many :messages, :after_add => :notify_members

  validates_presence_of :subject
  
  def notify_members(message)
    puts "Hello"
    self.conversation_memberships.all(:conditions => ["user_id != ?", message.user.id]).
each do |cm|

      cm.update_attribute(:new_messages, true)
    end
  end

  def unread_messages_for?(user)
    self.conversation_memberships(:conditions => {:user_id => user.id}).new_messages
  end
  
end
