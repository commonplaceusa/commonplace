class Post < ActiveRecord::Base
  CATEGORIES = %w{Request Offer Invitation Announcement Question}  

  delegate :neighborhood, :to => :user
  
  belongs_to :user
  belongs_to :community

  has_many :replies, :as => :repliable, :order => :created_at
  has_many :repliers, :through => :replies, :uniq => true, :source => :user
  validates_presence_of :user, :community
  validates_presence_of :subject, :message => "Please enter a subject for your post"
  validates_presence_of :body, :message => "Please enter some text for your post"

  attr_accessor :post_to_facebook

  scope :between, lambda { |start_date, end_date| 
    { :conditions => 
      ["posts.created_at between ? and ?", start_date.utc, end_date.utc] } 
  }
  scope :up_to, lambda { |end_date| { :conditions => ["posts.created_at <= ?", end_date.utc] } }

  scope :created_on, lambda { |date| { :conditions => ["posts.created_at between ? and ?", date.utc.beginning_of_day, date.utc.end_of_day] } }

  scope :today, :conditions => ["posts.created_at between ? and ?", DateTime.now.at_beginning_of_day, Time.now]

  def self.human_name
    "Neighborhood Post"
  end
  
  def category
    super || "Announcement"
  end
  
  def owner
    self.user
  end

end
