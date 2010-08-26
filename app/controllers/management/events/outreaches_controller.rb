class Management::Events::OutreachesController < ManagementController
  def index
    @event = Event.find(params[:event_id])
    @possible_attendees = User.tagged_with_aliases(@event.tags.map(&:name), :any => true)
  end
end
