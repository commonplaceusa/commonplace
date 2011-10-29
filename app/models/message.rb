class Message < ActiveRecord::Base
  #track_on_creation

  
  belongs_to :user
  belongs_to :messagable, :polymorphic => true
  validates_presence_of :subject, :body, :user, :messagable

  has_many :replies, :as => :repliable, :order => :created_at

  scope :today, :conditions => ["created_at between ? and ?", DateTime.now.at_beginning_of_day, DateTime.now]

  scope :between, lambda { |start_date, end_date| { :conditions => ["? <= created_at AND created_at < ?", start_date.utc, end_date.utc] } }
  
  def long_id
    IDEncoder.to_long_id(self.id)
  end
  
  def self.find_by_long_id(long_id)
    Message.find(IDEncoder.from_long_id(long_id))
  end

  
  def most_recent_body
    if replies.empty?
      self.body
    else
      replies.last.body
    end
  end

  def between?(start_date, end_date)
    start_date <= self.created_at and self.created_at <= end_date
  end
  
end
