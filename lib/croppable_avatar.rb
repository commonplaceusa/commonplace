module CroppableAvatar
  attr_accessor :crop_x, :crop_y, :crop_w, :crop_h

  def self.included(klass)
    klass.after_update :reprocess_avatar, :if => :cropping?
  end

  def cropping?
    !crop_x.blank? && !crop_y.blank? && !crop_w.blank? && !crop_h.blank?
  end
  
  def reprocess_avatar
    avatar.reprocess!
  end


end
