class Avatar < ActiveRecord::Base
  
  require 'open-uri'
  
  has_attached_file(:image, 
                    :styles => { 
                      :thumb => "100x100^", 
                      :normal => "120x120^",
                      :large => "200x200^"
                    },
                    :default_url => "/avatars/missing.png", 
                    :processors => [:cropper],
                    :url => "/system/avatar/:id/:style.:extension",
                    :path => ":rails_root/public/system/avatar/:id/:style.:extension" )
  belongs_to :owner, :polymorphic => true

  after_update :reprocess_image, :if => :cropping?
  
  attr_accessor :image_url
  
  after_create :download_remote_image, :if => :image_url_provided?

  validates_presence_of :avatar_remote_url, :if => :image_url_provided?, :message => 'is invalid or inaccessible'

  attr_accessor :x, :y, :w, :h

  def cropping?
    [x,y,w,h].all? {|b| !b.blank?}
  end

  def image_geometry(style = :original)
    @geometry ||= {}
    @geometry[style] ||= Paperclip::Geometry.from_file(image.path(style))
  end
  
  def image_url_provided?
    !self.avatar_remote_url.blank?
  end

  def download_remote_image
    self.image = do_download_remote_image
    self.avatar_remote_url = image_url
  end

  def do_download_remote_image
    io = open(URI.parse(self.avatar_remote_url))
    def io.original_filename; base_uri.path.split('/').last; end
    io.original_filename.blank? ? nil : io
  end

  private
  def reprocess_image
    image.reprocess!
  end

end
