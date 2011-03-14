require 'mustache'

require 'premailer'
require 'sass'

class MailBase < Mustache
  include MailUrls

  def self.underscore(classified = name)
    classified = name if classified.to_s.empty?
    classified = superclass.name if classified.to_s.empty?

    string = classified.dup.split("#{view_namespace}::").last

    string.split('::').map do |part|
      part[0] = part[0].chr.downcase
      part.gsub(/[A-Z]/) { |s| "_#{s.downcase}"}
    end.join('/')
  end

  self.template_path = File.dirname(__FILE__) + '/templates'

  def self.render(*args, &block)
    if block_given?
      new(*args, &block).render
    else
      super(*args)
    end
  end
  
  def render(*args)
    Premailer.new(super(*args), :with_html_string => true).to_inline_css
  end

  def styles
    style_file = self.class.ancestors.map { |klass| 
      File.join(File.dirname(__FILE__), "stylesheets/#{MailBase.underscore(klass.name)}.scss") 
    }.find {|filename| File.exist?(filename) }
    puts style_file.inspect
    Sass::Engine.for_file(style_file, :syntax => :scss).render if style_file
    
  end

end
