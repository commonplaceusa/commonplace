class Announcement < ActiveRecord::Base


  has_many :replies, :as => :repliable, :order => :created_at
  has_many :repliers, :through => :replies, :uniq => true, :source => :user
  belongs_to :owner, :polymorphic => true
  belongs_to :community

  validates_presence_of :subject, :body, :feed, :unless => Proc.new { |announcement| announcement.type.to_s == 'TwitterAnnouncement'}

  named_scope :between, lambda { |start_date, end_date| 
    { :conditions => 
      ["? <= created_at AND created_at < ?", start_date, end_date] } 
  }


  
  def time
    Helper.help.post_date(self.created_at)
  end 
  
  def feed
    self.owner
  end
  
  def long_id
    IDEncoder.to_long_id(self.id)
  end
  
  def self.find_by_long_id(long_id)
    Announcement.find(IDEncoder.from_long_id(long_id))
  end

end
