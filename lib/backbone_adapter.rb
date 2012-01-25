class BackboneAdapter
  def self.link(object, text)
    case object
    when Post
      "<a data-remote href='/show/posts/#{object.id}'>#{text}</a>"
    when Event
      "<a data-remote href='/show/events/#{object.id}'>#{text}</a>"
    when GroupPost
      "<a data-remote href='/show/group_posts/#{object.id}'>#{text}</a>"
    when Announcement
      "<a data-remote href='/show/announcements/#{object.id}'>#{text}</a>"
    when Reply
      BackboneAdapter.link(object.repliable, text)
    end
  end
end
