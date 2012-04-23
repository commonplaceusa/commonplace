Home.ui.Post = Framework.View.extend
  template: "home.post"

  className: "wire"

  render: ->
    presenter = new Home.presenter.Post(this.model)
    this.$el.html this.renderTemplate(presenter.toJSON())



