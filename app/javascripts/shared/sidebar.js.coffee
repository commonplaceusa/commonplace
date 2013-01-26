CommonPlace.shared.Sidebar = CommonPlace.View.extend
  template          : "shared.sidebar"
  id                : "sidebar"

  initialize: (options) ->
    @nav = options.nav
    @directory = options.directory
    @options = options

  afterRender: ->
    self = this
    @nav.render()
    @$("#your-town").replaceWith(@nav.el)

    @directory.render()
    @$("#directory").replaceWith(@directory.el)

