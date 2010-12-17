module TranslationHelper
  def translate_with_defaults(key, options = {})
    @default_translate_options ||= {}
    translate(key, @default_translate_options.merge(options))
  end

  alias :t :translate_with_defaults

end
