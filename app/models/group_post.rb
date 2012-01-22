class GroupPost < ActiveRecord::Base
  #track_on_creation

  belongs_to :user
  belongs_to :group

  has_many :replies, :as => :repliable, :order => :created_at
  has_many :repliers, :through => :replies, :uniq => true, :source => :user
  has_many :thanks, :as => :thankable

  validates_presence_of :subject, :message => "Please enter a subject for your post"
  validates_presence_of :body, :message => "Please enter some text for your post"

  scope :today, where("group_posts.created_at between ? and ?", Date.today, Time.now)
  scope :this_week, where("group_posts.created_at between ? and ?", DateTime.now.at_beginning_of_week, DateTime.now)

  scope :between, lambda { |start_date, end_date| { :conditions => ["? <= created_at AND created_at < ?", start_date.utc, end_date.utc] } }

  default_scope where(:deleted_at => nil)

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
    self.user.community
  end

  def between?(start_date, end_date)
    start_date <= self.created_at and self.created_at <= end_date
  end

  def profile_history_humanize
    begin
      "#{self.owner.first_name} posted '#{self.subject}' to '#{self.group.name}'"
    rescue
      nil
    end
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
    time :created_at
  end

end
