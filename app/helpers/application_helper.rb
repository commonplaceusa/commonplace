# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def with_format(format, &block)
    old_format = @template_format
    @template_format = format
    result = block.call
    @template_format = old_format
    return result
  end
  
  def render_tag_list things 
    content_tag(:ul, {:class => 'list'}) do
      things.map do |thing|
        content_tag(:li) do
          thing.name
        end
      end
    end
  end
  
  def tab_to(name, options = {}, html_options = {})
    html_options[:class] ||= ""
    html_options[:class] =  " selected_tab" if current_page?(options)
    link_to(name, options, html_options)
  end
  
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
          
    # if diff < -6
    #   return "in" + time_ago_in_words(time)
    #   return time.strftime("%A, %B %d, %Y at %I:%M%p")
    # elsif diff >= -6 and diff < -1
    #   return "last " + time.strftime("%A") + " at " + time.strftime("%I:%M%p")
    # elsif diff >= -1 and diff < 0
    #   return "yesterday at " + time.strftime("%I:%M%p")
    # elsif diff == 0
    #   return "today at " + time.strftime("%I:%M%p")
    # elsif diff >= 1 and diff < 0
    #   return "tomorrow at " + time.strftime("%I:%M%p")
    # elsif diff > 1 and diff <= 6
    #   return "this " + time.strftime("%A") + " at " + time.strftime("%I:%M%p")
    # else
    #   return time.strftime("%A, %B %d, %Y at %I:%M%p")
    # end

  end
end
