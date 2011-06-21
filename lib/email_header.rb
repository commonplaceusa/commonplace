require "RMagick"
class EmailHeader
  
  def initialize(community)
    @community = community
  end

  def background_color
    "#1c334a"
  end

  def community_name
    @community.name
  end

  def self.erb_template
    ERB.new(File.read(Rails.root.join("lib", "templates", "email_header.svg.erb")))
  end

  def s3_file_name
    "headers/#{@community.slug}.png"
  end

  def identifier
    "header-#{@community.slug}"
  end

  def template_file_name
    Rails.root.join("lib", "templates", "email_header.svg.erb")
  end
end
