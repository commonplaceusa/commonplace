module Paperclip
  class Cropper < Thumbnail
    def transformation_command
      if crop_command

        crop_command + super
      else
        super
      end
    end
    
    def crop_command
      target = @attachment.instance
      if target.cropping?
        ["-crop","#{target.w.to_i}x#{target.h.to_i}+#{target.x.to_i}+#{target.y.to_i}"]
      end
    end
  end
end
