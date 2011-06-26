class Feed < ActiveRecord::Base

  validates_presence_of :name, :community
  validates_presence_of :about, :if => lambda { |f| f.user_id }
  
  validates_attachment_presence :avatar

  validates_uniqueness_of :slug, :scope => :community_id, :allow_nil => true

  before_validation(:on => :create) do
    if self.slug?
      sanitize_slug
    else
      generate_slug
    end
    true
  end

  belongs_to :community
  belongs_to :user

  has_many :events, :dependent => :destroy, :as => :owner, :include => :replies

  has_many :announcements, :dependent => :destroy, :as => :owner, :include => :replies

  has_many :subscriptions, :dependent => :destroy
  has_many :subscribers, :through => :subscriptions, :source => :user, :uniq => true

  def live_subscribers
    self.subscriptions.all(:conditions => "receive_method = 'Live'").map &:user
  end

  has_attached_file(:avatar,                    
                    :styles => { 
                      :thumb => "100x100#", 
                      :normal => "120x120#",
                      :large => "200x200#"
                    },
                    :default_url => "/avatars/missing.png", 
                    :storage => :s3,
                    :s3_protocol => "https",
                    :bucket => "commonplace-avatars-#{Rails.env}",
                    :path => "/feeds/:id/avatar/:style.:extension",
                    :s3_credentials => {
                      :access_key_id => ENV['S3_KEY_ID'],
                      :secret_access_key => ENV['S3_KEY_SECRET']
                    })
                    

  def tag_list
    self.cached_tag_list
  end

  def tag_list=(string)
    self.cached_tag_list = string
  end

  def website=(string)
    if string.present? && !(string =~ /^https?:\/\//)
      super("http://" + string)
    else
      super(string)
    end
  end
  
  def avatar_url(style_name = nil)
    self.avatar.url(style_name || self.avatar.default_style)
  end


  def wire
    (self.announcements + self.events).sort_by do |item|
      time = case item
             when Event then item.created_at
             when Announcement then item.created_at
             end 
      (time - Time.now).abs
    end
  end

  def is_news
    self.kind == 4
  end
  
  def self.kinds
    feed_kinds = ActiveSupport::OrderedHash.new
    feed_kinds["A non-profit"] = 0
    feed_kinds["A community group"] = 1
    feed_kinds["A business"] = 2
    feed_kinds["A municipal entity"] = 3
    feed_kinds["A newspaper, news service, or news blog"] = 4
    feed_kinds["Other"] = 5
    feed_kinds
  end

  private

  def sanitize_slug
    string = self.slug.split("@").first
    string.gsub!(/[']+/, '')
    string.gsub!(/\W+/, ' ')
    string.gsub!(/\W+/, ' ')
    string.strip!
    string.downcase!
    string.gsub!(' ', '-')
    self.slug = string
  end

  def generate_slug
    string = self.name.mb_chars.normalize(:kd).gsub(/[^\x00-\x7F]/n, '').to_s
    string.gsub!(/[']+/, '')
    string.gsub!(/\W+/, ' ')
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
