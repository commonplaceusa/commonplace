module EventsHelper
  def toggle_attendance_for(event,user)
    if user.events.exists? event
      link_to 'RSVP', attendance_path(user.attendances(:conditions => {:event_id, event.id}).first), 'data-remote' => true, 'data-method' => :delete, :class => 'rsvp'
    else
      link_to 'RSVP', event_attendances_path(event), 'data-remote' => true, 'data-method' => :post, :class => 'rsvp'
    end
  end

end
