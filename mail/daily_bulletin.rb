class DailyBulletin < MailBase

  def initialize(user_id, date, posts, group_posts, transactions, announcements, events, weather)
    @user = User.find(user_id)
    @date = DateTime.parse(date)
    @posts = posts
    @group_posts = group_posts
    @transactions = transactions
    @announcements = announcements
    @events = events
    @weather = weather
  end

  def user
    @user
  end

  def community
    user.community
  end

  def logo_url
    asset_url("logo2.png")
  end

  def invite_them_now_button_url
    asset_url("invite-them-now-button.png")
  end

  def header_image_url
    community_slug = community.slug.downcase
    asset_url("headers/daily_bulletin/#{community_slug}.png")
  end

  # TODO: Do this more elegantly. To make daily digests idempotent, this had to be hacked together.
  def short_user_name
    user.first_name
  end

  def new_user_count
    community.users.this_week.count
  end

  def community_user_count
    community.user_count
  end

  def post_count
    @posts.count
  end

  def announcement_count
    @announcements.count
  end

  def text
    # TODO: Do this more elegantly. To make daily digests idempotent, this had to be hacked together.
    @text ||= YAML.load_file(File.join(File.dirname(__FILE__), "text", "#{community.locale}.yml"))[self.underscored_name]
  end

  def message_text
    "Hello #{community_name}! It's currently #{current_temp} degrees outside with a high today of #{high_today} degrees#{rain?}. In the past week, #{new_user_count} of your neighbors have joined OurCommonPlace #{community_name}, making the network #{community_user_count} people strong. In the past day, the community has shared #{post_count} neighborhood posts and #{announcement_count} organization announcements. Enjoy!"
  end

  def from
    "#{community_name} CommonPlace <notifications@#{community.slug}.ourcommonplace.com>"
  end

  def subject
    "The #{community_name} CommonPlace Daily Bulletin"
  end

  def to
    user.email
  end

  def header_text
    @date.strftime("%A, %B %d, %Y")
  end

  def month_short
    @date.strftime("%b")
  end

  def month_long
    @date.strftime("%B")
  end

  def day_of_month
    @date.strftime("%e")
  end

  def day_of_week
    @date.strftime("%A")
  end

  def current_temp
    Integer (@weather.current.temperature.fahrenheit)
  end

  def high_today
    Integer (@weather.forecast.first.high.fahrenheit)
  end

  def low_today
    Integer (@weather.forecast.first.low.fahrenheit)
  end

  def pop_today
    Integer (@weather.forecast.try(:first).try(:pop) || 0)
  end

  def rain?
    pop = pop_today
    if pop > 25
      " and a #{pop}% chance of #{rain_or_snow}"
    end
  end

  def rain_or_snow
    high = high_today
    low = low_today
    rain_snow = "rain/snow"
    if high < 32
      rain_snow = "snow"
    elsif low > 32
      rain_snow = "rain"
    end
    rain_snow
  end

  def community_name
    community.name
  end

  def deliver?
    posts_present || announcements_present || events_present
  end

  def deliver
    if deliver?
      # increase_email_count
      mail_headers = {
        "Precedence" => "list",
        "Auto-Submitted" => "auto-generated",
        "X-Mailgun-Tag" => self.tag
      }

      mail_headers.merge!({"X-Mailgun-Campaign-Id" => "#{community.slug.downcase}_#{format_tag(self.tag.downcase)}"})

      mail = Mail.deliver(:to => self.to,
                          :from => self.from,
                          :reply_to => self.reply_to,
                          :subject => self.subject,
                          :content_type => "text/html",
                          :body => self.render_html,
                          :charset => 'UTF-8',
                          :headers => mail_headers
      )
    end
  end

  def posts_present
    @posts.present?
  end

  def posts
    @posts.each do |p|
      p.body.gsub!(/\n/, "<br>")
    end

    @posts
  end

  def group_posts_present
    @group_posts.present?
  end

  def group_posts
    @group_posts.each do |p|
      p.body.gsub!(/\n/, "<br>")
    end

    @group_posts
  end

  def transactions_present
    @transactions.present?
  end

  def transactions
    @transactions.each do |p|
      p.body.gsub!(/\n/, "<br>")
    end

    @transactions
  end

  def announcements_present
    @announcements.present?
  end

  def announcements
    @announcements.each do |p|
      p.body.gsub!(/\n/, "<br>")
    end

    @announcements
  end

  def events_present
    @events.present?
  end

  def events
    @events.each do |p|
      p.body.gsub!(/\n/, "<br>")
    end

    @events
  end

  def tag
    'daily_bulletin'
  end

  def paid_advertisement_url
    if community.slug.downcase == ''
      return ''
    elsif community.slug.downcase == 'fallschurch'
      return 'http://www.fotanzania.org/'
    else
      return nil
    end
  end

  def paid_advertisement_img_url
    if community.slug.downcase == ''
      return asset_url('')
    elsif community.slug.downcase == 'fallschurch'
      return asset_url('paid_advertisements/fallschurch/fotanzania.jpg')
    else
      return nil
    end
  end

  def paid_advertisement_url2
    if community.slug.downcase == 'fallschurch'
      return 'http://kathysellsvirginiahomes.com/'
    else
      return nil
    end
  end

  def paid_advertisement_img_url2
    if community.slug.downcase == 'fallschurch'
      return asset_url('paid_advertisements/fallschurch/Symanski.jpg')
    else
      return nil
    end
  end  
end
