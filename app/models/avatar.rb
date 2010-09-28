class Avatar < ActiveRecord::Base
  has_attached_file(:image, 
                    :styles => { 
                      :thumb => "100x100^", 
                      :normal => "120x120^",
                      :large => "200x200^"},
                    :default_url => "/avatars/missing.png", 
                    :processors => [:cropper],
                    :url => "/system/avatar/:id/:style.:extension",
                    :path => ":rails_root/public/system/avatar/:id/:style.:extension" )
  belongs_to :owner, :polymorphic => true

  after_update :reprocess_image, :if => :cropping?

  attr_accessor :x, :y, :w, :h

  def cropping?
    [x,y,w,h].all? {|b| !b.blank?}
  end

  def image_geometry(style = :original)
    @geometry ||= {}
    @geometry[style] ||= Paperclip::Geometry.from_file(image.path(style))
  end

  private
  def reprocess_image
    image.reprocess!
  end

end
