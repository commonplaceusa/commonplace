class Post < ActiveRecord::Base
  CATEGORIES = %w{Request Offer Invitation Announcement Question}  
  include IDEncoder

  delegate :neighborhood, :to => :user
  
  belongs_to :user
  belongs_to :community

  has_many :replies, :as => :repliable, :order => :created_at
  has_many :repliers, :through => :replies, :uniq => true, :source => :user
  validates_presence_of :user, :community
  validates_presence_of :subject, :message => "Please enter a subject for your post"
  validates_presence_of :body, :message => "Please enter some text for your post"

  attr_accessor :post_to_facebook

  def self.human_name
    "Neighborhood Post"
  end
  
  def long_id
    IDEncoder.to_long_id(self.id)
  end
  
  def self.find_by_long_id(long_id)
    Post.find(IDEncoder.from_long_id(long_id))
  end
  
  def category
    super || "Announcement"
  end
  
  def time
    Helper.help.post_date(self.created_at)
  end
  
  def owner
    self.user
  end
  
  def deleteLink
    if UserSession.find.user.admin? || self.user == UserSession.find.user
      "<a href='/posts/destroy/#{self.id}'><img src='/images/delete.png' /></a>"
    else
      ""
    end
  end
    
  
end
