Home.ui.Header = Framework.View.extend
  template: "home.header"

  render: ->
    this.$el.html this.renderTemplate()

