module ItemsHelper
  
  def item_tag(item, html_options = {}, &block)
    html_options[:class] = [html_options[:class], dom_class(item)].join(" ")
    html_options[:id] = dom_id(item)
    content_tag(:li, html_options, &block)
  end

end
