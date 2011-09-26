class OrganizerDataPoint < ActiveRecord::Base
  def community
    User.find(self.organizer_id).community
  end
end
