class Notification < ActiveRecord::Base
  belongs_to :user
  belongs_to :notifiable, :polymorphic => true

  validates_presence_of :notified, :notifiable
  
  after_create :enqueue
  
  @queue = :notifications
  
  def self.perform(id) 
    notification = Notification.find(id)
    NotificationsMailer.send("deliver_#{notification.notified_type.downcase}_#{notification.notifiable_type.downcase}", notification.notified, notification.notifiable)
  end
  
  protected
  
  def enqueue
    if RAILS_ENV == "production"
    else
      Notification.perform(self.id)
    end
  end

end
