module Trackable
  def track_posted_content
    KM.record("Posted: #{self.class.name}", {'community' => self.community.name || "No Community"})
    KM.record('posted content', {'content type' => self.class.name, 'community' => self.community.name})
  end

  def track_on_creation
    KM.identify(email)
    KM.alias(full_name, email)
    KM.record('signed up', {'community' => self.community.name})
    KM.record('activated', {'community' => self.community.name})
  end

  def track_on_deletion
    KM.record('canceled', {'community' => self.community.name})
  end
end
