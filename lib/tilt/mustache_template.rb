module Tilt
  # todo: automatically add -tpl suffix as extension is removed, so as to differentiate files.
  class MustacheTemplate < Template
    def self.default_mime_type
      'application/javascript'
    end

    # Do whatever preparation is necessary to setup the underlying template
    # engine. Called immediately after template data is loaded. Instance
    # variables set in this method are available when #evaluate is called.
    #
    # Subclasses must provide an implementation of this method.
    def prepare
    end

    # Execute the compiled template and return the result string. Template
    # evaluation is guaranteed to be performed in the scope object with the
    # locals specified and with support for yielding to the block.
    #
    # This method is only used by source generating templates. Subclasses that
    # override render() may not support all features.
    def evaluate(scope, locals, &block)
      <<-END
      (function() {
        this.Templates || (this.Templates = {});
        this.Templates[#{scope.logical_path.inspect.gsub("/",".")}] = #{data.inspect};
      })();
      END
    end
  end
end
