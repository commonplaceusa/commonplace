# The base class for all CommonPlace Backbone Views
window.Framework.View = Backbone.View.extend

  # Renders a template
  #
  # Params:
  #   templateName - The name of the template to render
  #   params - the params object to render with
  #
  # Returns a string of HTML
  renderTemplate: (params) ->
    templateName = this.getTemplate()
    if !Templates[templateName]
      throw new Error("template '" + templateName + "' does not exist");

    Mustache.to_html(Templates[templateName], params, Templates)

  # Gets the View's template
  #
  # Checks @options.template (passed in with new View(template: name)) first,
  # then falls back to @template
  getTemplate: -> @options.template || @template
