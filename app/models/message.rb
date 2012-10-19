class Message < ActiveRecord::Base
  include Trackable
  after_create :track_posted_content

  belongs_to :user#, :counter_cache => true
  belongs_to :messagable, :polymorphic => true
  validates_presence_of :subject, :body, :user, :messagable

  has_many :replies, :as => :repliable, :order => :created_at, :dependent => :destroy

  scope :today, :conditions => ["messages.created_at between ? and ?", DateTime.now.at_beginning_of_day, DateTime.now]

  scope :between, lambda { |start_date, end_date| { :conditions => ["? <= messages.created_at AND messages.created_at < ?", start_date.utc, end_date.utc] } }

  def replied_at
    read_attribute(:replied_at) == nil ? self.updated_at : read_attribute(:replied_at)
  end

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

  def community
    user.community
  end

  # Tells us whether the given user has participated in this conversation
  #
  # params:
  #   user - the user we're asking about
  #
  # Returns true if the user is the owner of the message or any of the
  # message's replies
  def thread_member?(user)
    user == self.user || (messagable_type == "User" && messagable_id == user.id) || self.replies.map(&:user).include?(user)
  end
end
