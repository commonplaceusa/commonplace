$ ->

  slug = window.location.pathname.split("/")[1]

  account = new Home.model.Account

  window.router = new Home.Router();

  (new Home.model.Account).fetch

    success: (account) ->

      router.account = account

      (new Home.model.Community(slug: slug)).fetch
        success: (community) ->

          router.community = community

          Backbone.history.start(pushState: true)

        error: ->
          alert "we couldn't load the community"

    error: ->
      alert "you're not logged in. Go log in somewhere and come back"



