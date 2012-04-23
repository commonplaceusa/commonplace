Home.ui.Sidebar = Framework.View.extend
  template: "home.sidebar"

  render: ->
    this.$el.html this.renderTemplate()

    this.neighbors = new Home.ui.Neighbors(el: this.$("#neighbors"))
    this.neighbors.render()

    this.yourPages = new Home.ui.YourPages(el: this.$("#your-pages"))
    this.yourPages.render()

