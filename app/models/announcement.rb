class Announcement < ActiveRecord::Base


  has_many :replies, :as => :repliable, :order => :created_at
  has_many :repliers, :through => :replies, :uniq => true, :source => :user
  belongs_to :owner, :polymorphic => true
  belongs_to :community

  validates_presence_of :subject, :body, :feed, :unless => Proc.new { |announcement| announcement.type.to_s == 'TwitterAnnouncement'}

  scope :between, lambda { |start_date, end_date| 
    { :conditions => 
      ["? <= created_at AND created_at < ?", start_date, end_date] } 
  }

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
