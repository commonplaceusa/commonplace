module ModalHelper 
  def as_modal(options = {}, &block)
    options = {
      :class => "",
      :close => true
    }.merge(options)
    
    content_for(:modal) do
      content_tag(:div, :class => "not_empty", :id => "modal") do
        content_tag(:div, :id => "modal-overlay"){} +
        content_tag(:div, :id => "modal-content", :class => options[:class]) do
          if options[:close]
            link_to("close", :id => "modal-close", 'data-remote' => true) do
              image_tag 'modal-close.png'
            end + 
              capture(&block)
          else
            capture(&block)
          end
        end
      end
    end
  end
end
