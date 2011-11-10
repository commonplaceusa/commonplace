# currently files are included alphabetically.  This could be changed.
# but perhaps its nice to ensure include order just the same as an IDE view.

class window.WireHeader extends CommonPlace.View
  constructor: (options) ->
    super(options)
    @options = options

  template: 'wires.header'

  events:{
    "click .sub-navigation": "loadCurrent"
  }

  afterRender: () ->
    # bind events so that form can be moved in the dom.
    @options.$searchForm = @$("form.search")
    @options.submiter = _.debounce(() =>
      @options.$searchForm.submit()
    , CommonPlace.autoActionTimeout)

    @$('.cancelSearch').bind 'click', @cancelSearch
    @options.$searchForm
      .bind('keyup', @autoSearch) # in coffee, be sure to use prens when chaining
      .bind('submit', @search)

  autoSearch: () =>
    if  $('input', @options.$searchForm) == ''
      $('.cancelSearch', @options.$searchForm).hide()
    else
      $('.cancelSearch', @options.$searchForm).show()
    @options.submiter.apply(this)

  search: () => # don't require a passed event
    $(".wire").trigger('search',{query: $('form.search input').val()})
    return false

  cancelSearch: (event) =>
    event.preventDefault()
    $('form.search input').val('').focus()
    $('.cancelSearch', @options.$searchForm).hide()
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