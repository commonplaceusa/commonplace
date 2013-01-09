class Image < ActiveRecord::Base

  belongs_to :user
  belongs_to :imageable, :polymorphic => true

  acts_as_api

  api_accessible :default do |t|
    t.add :id
    t.add :user_id
    t.add :image_file_name
    t.add :image_file_size
    t.add :image_content_type
    t.add :image_url_default
    t.add lambda {|i| i.image_url(:normal)}, :as => :image_url
    t.add :image_updated_at
  end

  include CroppableAvatar
  has_attached_file(:image,
                    {:styles => {
                        :thumb => {:geometry => "100x100", :processors => [:cropper]},
                        :normal => {:geometry => "250x250", :processors => [:cropper]},
                        :large => {:geometry => "500x500", :processors => [:cropper]},
                        :original => "1000x1000>"
                      },
                      :default_url => "https://s3.amazonaws.com/commonplace-images-production/missing.png"
                    }.merge(Rails.env.development? || Rails.env.test? ?
                            { :path => ":rails_root/public/system/images/:id/:style.:extension",
                              :storage => :filesystem,
                              :url => "/system/images/:id/:style.:extension"
                            } : {
                              :storage => :s3,
                              :s3_protocol => "https",
                              :bucket => "commonplace-images-#{Rails.env}",
                              :path => "/images/:id/:style.:extension",
                              :s3_credentials => {
                                :access_key_id => ENV['S3_KEY_ID'],
                                :secret_access_key => ENV['S3_KEY_SECRET']
                              }
                            }))

  def image_url(style_name = nil)
    self.image.url(style_name || self.image.default_style)
  end

  def image_url_default
    self.image.url(self.image.default_style)
  end
end
