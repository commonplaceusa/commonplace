class Group < ActiveRecord::Base
  
  validates_presence_of :name, :slug, :about, :community

  before_validation_on_create :generate_slug, :unless => :slug?

  belongs_to :community
  
  has_many :group_posts

  has_attached_file(:avatar,                    
                    :styles => { 
                      :thumb => "100x100^", 
                      :normal => "120x120^",
                      :large => "200x200^"
                    },
                    :default_url => "/avatars/missing.png", 
                    :url => "/system/groups/:id/avatar/:style.:extension",
                    :path => ":rails_root/public/system/groups/:id/avatar/:style.:extension")

  def avatar_url(style = style_name = nil)
    self.avatar.url(style_name || self.avatar.default_style)
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
