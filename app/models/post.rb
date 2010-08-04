class Post < ActiveRecord::Base
  
  belongs_to :user

  has_many :thread_memberships, :as => :thread
  has_many :users, :through => :thread_memberships, :as => :thread
  has_many :replies, :after_add => :mark_thread_unread

  validates_presence_of :user
  validates_presence_of :body, :message => "Please enter some text for your post"
  
  protected

  def mark_thread_unread(message)
    self.thread_memberships.find(:all,:conditions => ["user_id != ?", message.user.id]).each(&:mark_unread!)
    unless self.thread_memberships.exists?(message.user)
      self.users << message.user
    end
  end


end
