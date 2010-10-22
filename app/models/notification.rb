class Notification < ActiveRecord::Base
  belongs_to :notified, :polymorphic => true
  belongs_to :notifiable, :polymorphic => true

  validates_presence_of :notified, :notifiable
  
  after_create :enqueue
  
  protected
  
  def enqueue

    if RAILS_ENV == "production"
      Resque.enqueue(NotificationsMailer,
                     notified.class.to_s, notifiable.class.to_s, 
                     notified.id, notifiable.id)
    else
      NotificationsMailer.perform(notified.class.to_s, notifiable.class.to_s, 
                                  notified.id, notifiable.id)
    end
  end

end
