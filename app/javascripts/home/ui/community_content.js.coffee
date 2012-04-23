Home.ui.CommunityContent = Framework.View.extend
  template: "home.community-content"

  className: "main"

  render: ->
    console.log "content render"
    this.$el.html this.renderTemplate()

    router.community.getPosts
      limit: 5
      success: (posts) =>
        posts.each (p) =>
          view = new Home.ui.Post(model: p)
          view.render()
          this.$(".list").append(view.el)






