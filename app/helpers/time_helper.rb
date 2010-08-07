module TimeHelper
  
  def hours_minutes time
    return time.strftime("%I:%M %p")[/(^0)(.+)/, 2] # strip leading zero
  end
  
  def post_date time 
    unless time
      return ""
    end
    
    diff = ( DateTime.now.to_i - time.to_i ) / 86400
    
    if diff < 7
      return time_ago_in_words(time, include_seconds = true) + " ago"
    elsif diff < 365
      return time.strftime("%b %d")
    else
      return time.strftime("%b %d %Y")
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
  
end