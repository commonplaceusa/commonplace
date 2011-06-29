require 'mustache'
require 'premailer'
require 'sass'
require 'resque/plugins/resque_heroku_autoscaler'

Mail.defaults do
  delivery_method($MailDeliveryMethod.intern,
                  $MailDeliveryOptions.symbolize_keys)
end

class MailBase < Mustache
  include MailUrls
  extend Resque::Plugins::HerokuAutoscaler

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

  def community
  end
  
  def render(*args)
    Premailer.new(super(*args), :with_html_string => true).to_inline_css
  end

  def styles
    style_file = self.class.ancestors.map { |klass| 
      File.join(File.dirname(__FILE__), "stylesheets/#{MailBase.underscore(klass.name)}.scss") 
    }.find {|filename| File.exist?(filename) }

    Sass::Engine.for_file(style_file, :syntax => :scss).render if style_file
  end

  def markdown(text = "")
    BlueCloth.new(text).to_html
  end

  def from
    "#{community.name} CommonPlace <notifications@#{community.slug}.ourcommonplace.com>"
  end

  def reply_to
    nil
  end

  def to 
    user.email
  end

  def subject
    "Notification from CommonPlace"
  end

  def deliver?
    true
  end

  def deliver
    if deliver?
      mail = Mail.deliver(:to => self.to,
                          :from => self.from,
                          :reply_to => self.reply_to,
                          :subject => self.subject,
                          :content_type => "text/html",
                          :body => self.render,
                          :headers => {
                            "Precedence" => "list",
                            "Auto-Submitted" => "auto-generated",
                            "X-Campaign-Id" => community ? community.slug : "administrative"
                          })
    end
  end

  def self.queue 
    :notifications
  end

  def self.perform(*args)
    new(*args).deliver
  end
end
