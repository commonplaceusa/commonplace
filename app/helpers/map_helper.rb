module MapHelper
  
  def render_map(&block)
    content_tag(:div, "",  'data-map' => Mapifier.new(&block).to_json)
  end
end    
