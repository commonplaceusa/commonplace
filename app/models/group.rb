class Group < ActiveRecord::Base
  
  validates_presence_of :name, :slug, :about, :community

  belongs_to :community

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

  
end
