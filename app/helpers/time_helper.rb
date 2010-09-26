module TimeHelper
  
  def full_date(date,time)
    date.strftime("%A, %B %d") + " at " + hours_minutes(time)
  end
  
  def hours_minutes time
    return time.strftime("%I:%M %p").sub(/^0/,'') # strip leading zero
  end
  
  def post_date time 
    unless time
      return ""
    end
    
    diff = ( DateTime.now.to_i - time.to_i ) / 86400
    
    if diff < 7
      return time_ago_in_words(time, include_seconds = true) + " ago"
    elsif diff < 365
      return time.strftime("%B %d")
    else
      return time.strftime("%B %d %Y")
    end
  end


  def event_date time 
    unless time
      return ""
    end
    
    time_string = time_ago_in_words(time)
    diff = ( time.to_i - DateTime.now.to_i ) / 86400
    if diff < 0
      return time_string + " ago"
    else
      return "in " + time_string
    end
  end
  
  def drop_down_times
    ((5..23).to_a + (0..4).to_a).map{ |h|
      0.step(59, 30).map{ |m| Time.parse("#{h}:#{m}").to_s }
    }.flatten
  end
  
  def event_select_time(edge)
    content_tag(:li, :class => 'select required', :id => "event_#{edge}_input") do 
      content_tag(:label, :for => "event_#{edge}") { edge.humanize } +
        select('event', edge, options_for_select(drop_down_times, @event.read_attribute(edge).to_s))
    end
  end
  
end
