 module ApplicationHelper
   
   def creation_feeds_for(user)
     ActiveSupport::OrderedHash.new.tap do |collection|
       ([ user ] + user.managable_feeds.to_a).each do |f|
         collection[f.name] = dom_id(f)
       end
     end
   end

   def html_to_json(&block)
     @template_format = :html
     result = block.call
     @template_format = :json
     return result.to_json
   end

   alias_method :h2j, :html_to_json

   def include_javascript_folder(folder)
     files = Dir.glob("#{ RAILS_ROOT }/public/javascripts/#{ folder }/*.js")
     files.map!{ |f| folder + "/" + File.basename(f) }
     javascript_include_tag files
   end
   
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

   def content_for?(name)
     raise "Delete content_for? in application_helper.rb" if RAILS_GEM_VERSION.to_i > 2
     ivar = "@content_for_#{name}"
     instance_variable_get(ivar).present?
   end
end
