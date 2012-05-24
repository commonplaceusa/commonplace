Home.ui.Modal = Framework.View.extend
  template: "home.modal"

  render: ->
    this.$el.html this.renderTemplate()
    this.$(".modal-container").html(this.options.view.el)
    this.center()

  center: ->
    # center it

  events:
    "click modal-shadow": -> this.remove()
