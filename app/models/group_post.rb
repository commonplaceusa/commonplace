class GroupPost < ActiveRecord::Base
  #track_on_creation

  belongs_to :group
  belongs_to :user

  has_many :replies, :as => :repliable, :order => :created_at
  has_many :repliers, :through => :replies, :uniq => true, :source => :user

  validates_presence_of :subject, :message => "Please enter a subject for your post"
  validates_presence_of :body, :message => "Please enter some text for your post"

  scope :today, where("group_posts.created_at between ? and ?", Date.today, Time.now)

  def owner
    self.user
  end

end
