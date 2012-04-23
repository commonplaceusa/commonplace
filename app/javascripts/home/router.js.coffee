Home.Router = Backbone.Router.extend
  routes:
    ":community/home" : "home"


  home: ->
    header = new Home.ui.Header el: $("header")
    header.render()

    sidebar = new Home.ui.Sidebar el: $("#sidebar")
    sidebar.render()

    content = new Home.ui.CommunityContent el: $("#content")
    content.render()

