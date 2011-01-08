class OutsideAnnouncement < Announcement
  validates_uniqueness_of :url
end
