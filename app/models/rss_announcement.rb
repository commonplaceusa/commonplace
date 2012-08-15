require 'rss'
require 'htmlentities'

class RSSAnnouncement < Announcement

  validates_uniqueness_of :subject, scope: [:url]

  def self.from_rss_item(item, params = {})
    self.record_timestamps = false

    timestamp = item.date.try(:to_datetime) || DateTime.now

    self.new(params) do |a|
      a.subject = item.title
      a.url = item.link
      a.body = self.extract_rss_body(item.description)
      a.created_at = timestamp
      a.updated_at = timestamp
    end
  ensure
    self.record_timestamps = true
  end

  def self.extract_rss_body(body)
    body = self.strip_feedflare(body)
    body = HTMLEntities.new.decode(body)
    body = ReverseMarkdown.new.parse_string(body)
    body
  end

  def self.strip_feedflare(html)
    html.gsub(/<div class=\"feedflare\">(.*)<\/div>/m, "")
  end

end
