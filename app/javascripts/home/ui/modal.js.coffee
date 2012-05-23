Home.ui.Modal = Framework.View.extend
  template: "home.modal"

  render: ->
    this.$el.html this.renderTemplate()
    this.$(".modal-container").html(this.options.view.el)
    this.center()

  center: ->
    # center it

  sendPost: ->
    params = "title": "Post Title", "body": "Static post content, need to change to get this content dynamically", "category": "conversation"
    router.community.sendPost(params)

  events:
    "click modal-shadow": -> this.remove()
    "click button": -> this.sendPost()
