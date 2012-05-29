Home.Router = Backbone.Router.extend
  routes:
    ":community/home" : "home"
    ":community/home/create-post": "createDefault"
    ":community/home/create-conversation": "createConvo"
    ":community/home/create-event": "createEvent"
    ":community/home/create-request": "createRequest"

  home: ->
    header = new Home.ui.Header el: $("header")
    header.render()

    sidebar = new Home.ui.Sidebar el: $("#sidebar")
    sidebar.render()

    content = new Home.ui.CommunityContent el: $("#content")
    content.render()

  createPost: ->
    posting = new Home.ui.Posting()
    posting.render()
    modal = new Home.ui.Modal(el: $("#modal"), view: posting)
    modal.render()
    return posting

  createDefault: ->
    posting = this.createPost()
    posting.showDefault "default"

  createConvo: ->
    posting = this.createPost()
    posting.show "conversation"

  createEvent: ->
    posting = this.createPost()
    posting.show "event"

  createRequest: ->
    posting = this.createPost()
    posting.show "request"
