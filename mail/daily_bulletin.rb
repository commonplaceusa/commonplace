class DailyBulletin < MailBase

  def initialize(user_email, user_first_name, user_community_name, community_locale, community_slug, date, posts, announcements, events)
    @user_email = user_email
    @user_first_name = user_first_name
    @user_community_name = user_community_name
    @community_locale = community_locale
    @community_slug = community_slug
    @date = DateTime.parse(date)
    @posts = posts
    @announcements = announcements
    @events = events
  end

  def logo_url
    asset_url("logo2.png")
  end

  def reply_button_url
    asset_url("reply-button.png")
  end

  def invite_them_now_button_url
    asset_url("invite-them-now-button.png")
  end

  # TODO: Do this more elegantly. To make daily digests idempotent, this had to be hacked together.
  def short_user_name
    @user_first_name
  end

  def text
    # TODO: Do this more elegantly. To make daily digests idempotent, this had to be hacked together.
    @text ||= YAML.load_file(File.join(File.dirname(__FILE__), "text", "#{@community_locale}.yml"))[self.underscored_name]
  end

  def from
    "#{community_name} CommonPlace <notifications@#{@community_slug}.ourcommonplace.com>"
  end

  def subject
    "The #{community_name} CommonPlace Daily Bulletin"
  end

  def to
    @user_email
  end

  def header_text
    @date.strftime("%A, %B %d, %Y")
  end

  def community_name
    @user_community_name
  end

  def deliver?
    posts_present || announcements_present || events_present
  end

  def deliver
    if deliver?
      email_id = EmailTracker.new_email({
          'recipient_email' => self.to,
          'email_type' => self.class.name,
          'tag_list' => self.tag_list,
          'main_tag' => self.tag,
          'originating_community_id' => (self.community) ? self.community.id : 0,
          'updated_at' => DateTime.now
      })
      # increase_email_count
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
                            "X-Mailgun-Tag" => self.tag,
                            "X-Mailgun-Variables" => {
                              email_id: email_id
                            }.to_json

                          })
      DailyStatistic.increment_or_create("#{self.tag}s_sent")
      KM.identify(self.to)
      KM.record('email sent', {
        type: self.tag,
        community: community ? community.slug : "administrative"
      })
      KM.record("#{self.tag} email sent", {
        type: self.tag,
        community: community ? community.slug : "administrative"
      })
    end
  end

  def posts_present
    @posts.present?
  end

  def posts
    @posts
  end

  def announcements_present
    @announcements.present?
  end

  def announcements
    @announcements
  end

  def events_present
    @events.present?
  end

  def events
    @events
  end

  def tag
    'daily_bulletin'
  end

end
