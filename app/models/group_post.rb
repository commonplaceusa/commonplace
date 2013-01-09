class GroupPost < ActiveRecord::Base
  include Trackable
  after_create :track_posted_content

  belongs_to :user
  belongs_to :group

  has_many :replies, :as => :repliable, :order => :created_at, :dependent => :destroy
  has_many :repliers, :through => :replies, :uniq => true, :source => :user
  has_many :thanks, :as => :thankable, :dependent => :destroy
  has_many :warnings, :as => :warnable, :dependent => :destroy

  validates_presence_of :subject, :message => "Please enter a subject for your post"
  validates_presence_of :body, :message => "Please enter some text for your post"

  scope :today, where("group_posts.created_at between ? and ?", Date.today, Time.now)
  scope :this_week, where("group_posts.created_at between ? and ?", DateTime.now.at_beginning_of_week, DateTime.now)

  scope :between, lambda { |start_date, end_date| { :conditions => ["? <= group_posts.created_at AND group_posts.created_at < ?", start_date.utc, end_date.utc] } }

  default_scope where(:deleted_at => nil)

  def has_reply
    self.replies.present?
  end

  def replied_at
    read_attribute(:replied_at) == nil ? self.updated_at : read_attribute(:replied_at)
  end

  def owner
    self.user
  end

  def community_id
    self.user.community_id
  end

  def community
    self.user.try(:community)
  end

  def between?(start_date, end_date)
    start_date <= self.created_at and self.created_at <= end_date
  end

  def all_thanks
    (self.thanks + self.replies.map(&:thanks)).flatten.sort_by {|t| t.created_at }
  end

  def all_flags
    (self.warnings + self.replies.map(&:warnings)).flatten.sort_by { |t| t.created_at }
  end

  acts_as_api

  api_accessible :history do |t|
    t.add :id
    t.add ->(m) { "group_posts" }, :as => :schema
    t.add :subject, :as => :title
    t.add ->(m) { m.group.name }, :as => :group_name
  end

  searchable do
    text :subject, :body
    text :replies do
      replies.map &:body
    end
    text :author_name do
      user.name
    end
    text :reply_author do
      replies.map { |r| r.user.name }
    end
    integer :community_id
    integer :user_id
    integer :reply_author_ids, :multiple => true do
      replies.map { |r| r.user.id }
    end
    time :created_at
  end

end
