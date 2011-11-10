module Tilt

  class I18nTemplate < Template
    def self.default_mime_type
      'application/javascript'
    end

    def prepare
    end

    def evaluate(scope, locals, &block)
      <<-END
      (function() {
        this.I18N || (this.I18N = {});
        this.I18N[#{scope.logical_path.inspect}] = #{data};
      })(this);
      END
    end
  end
end
