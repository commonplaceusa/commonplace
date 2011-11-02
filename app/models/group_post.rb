class GroupPost < ActiveRecord::Base
  #track_on_creation

  belongs_to :group
  belongs_to :user

  has_many :replies, :as => :repliable, :order => :created_at
  has_many :repliers, :through => :replies, :uniq => true, :source => :user

  validates_presence_of :subject, :message => "Please enter a subject for your post"
  validates_presence_of :body, :message => "Please enter some text for your post"

  scope :today, where("group_posts.created_at between ? and ?", Date.today, Time.now)

  scope :between, lambda { |start_date, end_date| { :conditions => ["? <= created_at AND created_at < ?", start_date.utc, end_date.utc] } }

  default_scope where(:deleted_at => nil)

  def owner
    self.user
  end

  def community_id
    self.user.community_id
  end

  def community
    self.user.community
  end

  def between?(start_date, end_date)
    start_date <= self.created_at and self.created_at <= end_date
  end

  searchable do
    text :subject
    text :body
    integer :community_id
    time :created_at
  end

end
