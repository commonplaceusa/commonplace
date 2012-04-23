$ ->
  header = new Home.ui.Header el: $("header")
  header.render()

  sidebar = new Home.ui.Sidebar el: $("#sidebar")
  sidebar.render()

  post = new Home.ui.Post
  post.render()
  $(".main").append post.el


