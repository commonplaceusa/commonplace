# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  def render_tag_list(things)
    content_tag(:ul, {:class => 'list'}) do
      things.map do |thing|
        content_tag(:li) do
          thing.name
        end
      end
    end
  end
  
  def human_date(it)
    if it
      now = DateTime.now
      diff = (it.to_i - now.to_i)/86400
      
      #if it.strftime("%I").include? "0"
      #  hour = it.strftime("%I").slice[1]
    
      #return hour
      
      if diff < -6
        return it.strftime("%A, %B %d, %Y at %I:%M%p")
      elsif diff >= -6 and diff < -1
        return "Last " + it.strftime("%A") + " at " + it.strftime("%I:%M%p")
      elsif diff >= -1 and diff < 0
        return "Yesterday at " + it.strftime("%I:%M%p")
      elsif diff == 0
        return "Today at " + it.strftime("%I:%M%p")
      elsif diff >= 1 and diff < 0
        return "Tomorrow at " + it.strftime("%I:%M%p")
      elsif diff > 1 and diff <= 6
        return "This " + it.strftime("%A") + " at " + it.strftime("%I:%M%p")
      else
        return it.strftime("%A, %B %d, %Y at %I:%M%p")
      end
    end
    else
    ""
  end
end
