class Group < ActiveRecord::Base
  #track_on_creation
  
  validates_presence_of :name, :slug, :about, :community

  before_validation(:on => :create) do
    generate_slug unless self.slug?
    true
  end


  belongs_to :community
  
  has_many :group_posts

  has_many :memberships
  has_many :subscribers, :through => :memberships, :source => :user, :uniq => true

  has_many :event_cross_postings
  has_many :events, :through => :event_cross_postings

  has_many :announcement_cross_postings
  has_many :announcements, :through => :announcement_cross_postings

  def avatar_url=(url)
    self.avatar_file_name = url
  end

  def avatar_url(style_name = nil)
    if Rails.env.development?
      self.avatar_file_name || "/avatars/missing.png"
    else
      "https://s3.amazonaws.com/commonplace-avatars-#{Rails.env}/groups/#{self.slug}.png"
    end
  end

  def live_subscribers
    self.memberships.all(:conditions => "memberships.receive_method = 'Live'").map &:user
  end

  def self.find_by_slug(slug)
    Group.where(slug: slug).first || Group.find_by_id(slug)
  end

  private

  def generate_slug
    string = self.name.mb_chars.normalize(:kd).gsub(/[^\x00-\x7F]/n, '').to_s
    string.gsub!(/[']+/, '')
    string.gsub!(/\W+/, ' ')
    string.strip!
    string.downcase!
    string.gsub!(' ', '-')

    if Feed.exists?(:slug => string, :community_id => self.community_id)
      self.slug = nil
    else
      self.slug = string
    end
  end
  
end
