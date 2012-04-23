$ ->

  slug = window.location.pathname.split("/")[1]
  community = new Home.model.Community(slug: slug)

  community.fetch
    success: ->
      window.router = new Home.Router();
      window.router.community = community

      Backbone.history.start(pushState: true)






