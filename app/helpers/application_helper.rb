 module ApplicationHelper

   def with_format(format, &block)
     old_format = @template_format
     @template_format = format
     result = block.call
     @template_format = old_format
     return result
   end

   def html_to_json(&block)
     @template_format = :html
     result = block.call
     @template_format = :json
     return result.to_json
   end

   def include_javascript_folder(folder)
     files = Dir.glob("#{ RAILS_ROOT }/public/javascripts/#{ folder }/*.js")
     files.map!{ |f| folder + "/" + File.basename(f) }
     javascript_include_tag files
   end

   def tab_to(name, options = {}, html_options = {}, &block)
     options, html_options = name, options if block

     html_options[:class] ||= ""
     html_options[:class] += " selected_nav" if current_page?(options)
     if block
       link_to(options, html_options, &block)
     else
       link_to(name, options, html_options)
     end
   end

   def link_to_add(text, options, html_options = {}) 
     html_options[:id] ||= ""
     html_options[:id] += "add"
     link_to(text, options, html_options)
   end

   def winnow_button(text, target, html_options = {})
     html_options['data-remote'] = true
     tab_to target, html_options do
       content_tag(:span, text)
     end
   end
  
end
