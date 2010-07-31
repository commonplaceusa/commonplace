class Attendance < ActiveRecord::Base
  include AASM
  belongs_to :event
  belongs_to :user

  aasm_column :current_state
  aasm_initial_state :read

  aasm_state :read
  aasm_state :unread

  aasm_event :view do
    transitions :to => :read, :from => [:read,:unread]
  end
  
  aasm_event :mark_unread do
    transitions :to => :unread, :from => [:read]
  end

end
