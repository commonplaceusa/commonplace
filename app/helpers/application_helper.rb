 module ApplicationHelper
   
   def tab_to(name, options = {}, html_options = {}, &block)
     options, html_options = name, options if block

     html_options[:class] ||= ""
     if current_page?(options) || current_page?(url_for(options) + ".json")
       html_options[:class] += " selected_nav"
     end
     if block
       link_to(options, html_options, &block)
     else
       link_to(name, options, html_options)
     end
   end

end
