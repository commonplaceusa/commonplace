module Trackable
  def track_posted_content
    KM.record('posted content', {'content type' => self.class.name})
  end

  def track_on_creation
    KM.identify(email)
    KM.alias(full_name, email)
    KM.record('signed up')
    KM.record('activated')
  end

  def track_on_deletion
    KM.record('canceled')
  end
end
