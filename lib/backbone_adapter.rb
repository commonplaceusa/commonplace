class BackboneAdapter
  def self.link(object, text)
    case object
    when Post
      "<a href='/#/show/posts/#{object.id}'>#{text}</a>"
    when Event
      "<a href='/#/show/events/#{object.id}'>#{text}</a>"
    when GroupPost
      "<a href='/#/show/group_posts/#{object.id}'>#{text}</a>"
    when Announcement
      "<a href='/#/show/announcements/#{object.id}'>#{text}</a>"
    when Reply
      BackboneAdapter.link(object.repliable, text)
    end
  end
end
