Home.ui.Post = Framework.View.extend
  template: "home.post"

  className: "wire"

  render: -> this.$el.html this.renderTemplate()

