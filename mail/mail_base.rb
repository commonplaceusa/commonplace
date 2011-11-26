require 'mustache'
require 'premailer'
require 'sass'

Mail.defaults do
  delivery_method($MailDeliveryMethod,
                  $MailDeliveryOptions)
end

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

  def underscored_name
    MailBase.underscore(self.class.name)
  end

  def text
    @text ||= YAML.load_file(File.join(File.dirname(__FILE__), "text", "#{community.locale}.yml"))[self.underscored_name]
  end
  
  def self.render_html(*args, &block)
    if block_given?
      new(*args, &block).render
    else
      self.render(*args)
    end
  end

  def community
  end

  def t
    lambda do |key|
      text[key] ? render(text[key]) : key
    end
  end
  
  def render_html(*args)
    Premailer.new(render(*args), :with_html_string => true, :inputencoding => 'UTF-8', :replace_html_entities => true).to_inline_css
  end

  def styles
    style_file = self.class.ancestors.map { |klass| 
      File.join(File.dirname(__FILE__), "stylesheets/#{MailBase.underscore(klass.name)}.scss") 
    }.find {|filename| File.exist?(filename) }

    Sass::Engine.for_file(style_file, :syntax => :scss).render if style_file
  end

  def markdown(text = "")
    Redcarpet.new(text).to_html
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

  def tag
    "administrative"
  end

  def deliver?
    unless limited?
      true
    else
      increase_email_count
      meets_limitation_requirement
    end
  end

  def limited?
    unless user
      true
    else
      user.emails_are_limited?
    end
  end

  def increase_email_count
    if user
      user.emails_sent += 1
      user.save
    end
  end

  def meets_limitation_requirement
    user && user.emails_sent <= 3
  end

  def deliver
    if deliver?
      mail = Mail.deliver(:to => self.to,
                          :from => self.from,
                          :reply_to => self.reply_to,
                          :subject => self.subject,
                          :content_type => "text/html",
                          :body => self.render_html,
                          :charset => 'UTF-8',
                          :headers => {
                            "Precedence" => "list",
                            "Auto-Submitted" => "auto-generated",
                            "X-Campaign-Id" => community ? community.slug : "administrative",
                            "X-Mailgun-Tag" => self.tag
                          })
    end
  end

  def self.queue 
    :notifications
  end

  def self.perform(*args)
    new(*args).deliver
  end

  def self.after_perform_heroku(*args)
    ActiveRecord::Base.connection.disconnect!
  end
  
  def self.on_failure_heroku(e, *args)
    ActiveRecord::Base.connection.disconnect!
  end
end
