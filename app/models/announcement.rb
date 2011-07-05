class Announcement < ActiveRecord::Base


  has_many :replies, :as => :repliable, :order => :created_at
  has_many :repliers, :through => :replies, :uniq => true, :source => :user
  belongs_to :owner, :polymorphic => true
  belongs_to :community

  validates_presence_of :subject, :body

  scope :between, lambda { |start_date, end_date| 
    { :conditions => 
      ["? <= announcements.created_at AND announcements.created_at < ?", start_date, end_date] } 
  }
  scope :up_to, lambda { |end_date| { :conditions => ["announcements.created_at <= ?", end_date.utc] } }

  scope :created_on, lambda { |date| { :conditions => ["announcements.created_at between ? and ?", date.utc.beginning_of_day, date.utc.end_of_day] } }

  scope :today, :conditions => ["announcements.created_at between ? and ?", DateTime.now.at_beginning_of_day, DateTime.now]

  def feed
    self.owner
  end

  def user
    if owner.is_a? Feed
      owner.user
    else
      owner
    end
  end

end
