module ActionView #:nodoc:
  module Helpers #:nodoc:
    module NestedLayoutsHelper

      # Wrap part of the template into layout.
      # All layout files must be in app/views/layouts.
      def inside_layout(layout, &block)
        layout_template = @template.view_paths.find_template(layout.to_s =~ /layouts\// ? layout : "layouts/#{layout}", :html)
        @template.instance_variable_set('@content_for_layout', capture(&block))
        concat( layout_template.render_template(@template) )
      end

      # Wrap part of the template into inline layout.
      # Same as +inside_layout+ but takes layout template content rather than layout template name.
      def inside_inline_layout(template_content, &block)
        @template.instance_variable_set('@content_for_layout', capture(&block))
        concat( @template.render(:inline => template_content) )
      end
    end
  end
end

ActionView::Base.send :include, ActionView::Helpers::NestedLayoutsHelper