# currently files are included alphabetically.  This could be changed.
# but perhaps its nice to ensure include order just the same as an IDE view.

class window.WireHeader extends CommonPlace.View
  constructor: (options) ->
    super(options)
    @options = options

  events:{
    "keyup form.search input": "debounceSearch"
    "submit form.search": "search"
    "click .cancelSearch": "cancelSearch"
    "click .sub-navigation": "loadCurrent"
    "click form.search": "stopPropagation"
  }

  debounceSearch: _.debounce () =>
    # todo: make this.$ functional for coffee classes.
    $("form.search").submit()
  , CommonPlace.autoActionTimeout

  search: () => # don't require a passed event
    $(".wire").trigger('search',{query: $('form.search input').val()})
    return false

  cancelSearch: (event) =>
    event.preventDefault()
    $('form.search input').val('').focus()
    @search()

  isSearchEnabled: () ->
    @isActive('wireSearch') && @options.search

  loadCurrent: (event) =>
    window.location = $('a.current', this.el).attr('href')

  stopPropagation: (event) ->
    event.stopPropagation()




class window.PreviewWire extends window.Wire
  constructor: (options) ->
    super(options)
    @options = options

  _defaultPerPage: 3

  fullWireLink: () ->
    @options.fullWireLink


class window.PaginatingResourceWire extends window.PaginatingWire
  # the usefulness of this class is questionable.
  constructor: (options) ->
      super(options)
  _defaultPerPage: 15


class window.ResourceWire extends window.Wire
  constructor: (options) ->
    super(options)
    @options = options

  usersLinkClass: () ->
    @options.active == 'users' ? 'current' : ''

  feedsLinkClass: () ->
    @options.active == 'feeds' ? 'current' : ''

  groupsLinkClass: () ->
    @options.active == 'groups' ? 'current' : ''