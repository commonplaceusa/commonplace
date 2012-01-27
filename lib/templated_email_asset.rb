require 'RMagick'
require 'tempfile'
class TemplatedEmailAsset

  def bucket_name
    "commonplace-mail-assets-production"
  end

  def upload!
    AWS::S3::Base.establish_connection!(
      :access_key_id     => ENV["S3_KEY_ID"],
      :secret_access_key => ENV["S3_KEY_SECRET"])
    AWS::S3::S3Object.store(self.s3_file_name, self.to_png, self.bucket_name)
  end

  def to_png
    svg_file = Tempfile.new(self.identifier + "png")
    svg_file.write(self.to_svg)
    png_file = Tempfile.new(self.identifier + "svg" )
    `inkscape --export-png #{png_file.path} #{svg_file.path}`
    png_file.read.tap do 
      svg_file.close
      png_file.close
    end
  end

  def to_svg
    self.erb_template.result(binding)
  end

  def background_color
    "transparent"
  end

  def erb_template
    ERB.new(File.read(self.template_file_name))
  end
  
end
