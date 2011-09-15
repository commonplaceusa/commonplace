module Tilt
  class MustacheTemplate < Template
    def self.default_mime_type
    'application/javascript'
    end
    
    def prepare
    end
    
    def evaluate(scope, locals, &block)
      <<-END
      (function() {
      this.Templates || (this.Templates = {});
      this.Templates[#{scope.logical_path.inspect}] = #{data.inspect};
      })(this);
      END
    end
  end
end
