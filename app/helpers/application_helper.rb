# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def include_javascript_folder(folder)
    files = Dir.glob("#{ RAILS_ROOT }/public/javascripts/#{ folder }/*.js")
    files.map!{ |f| folder + "/" + File.basename(f) }
    javascript_include_tag files
  end

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
  
  def user_organization_text
    if current_user.managable_organizations.length == 0 
      "Start an organization"
    else
      "Manage Organizations"
    end
  end
  
  def user_inbox_size
    "Inbox (1)"
  end
  
  def tab_to(name, options = {}, html_options = {})
    html_options[:class] ||= ""
    html_options[:class] = " selected_nav" if current_page?(options)
    link_to(name, options, html_options)
  end
  
  def display_or_none(field)
    field || '<span class="none">none listed</span>'
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
  end
end
