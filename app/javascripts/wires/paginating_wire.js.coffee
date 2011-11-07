class window.PaginatingWire extends window.Wire
  constructor: (options) ->
    super(options)
    @options = options

  events: {
    "click a.more": "showMore"
  }

  _defaultPerPage: 10,

  allFetched: () ->
    #currently, only the latest page is stored in the collection.  this maybe should change.
    (@collection.length < @perPage())

  showMore: (event) ->
    event.preventDefault()
    @scope['page'] += 1

    # this is a bit of a hack.  It reuses code to add li elements to the ul, without re-rendering the wire.
    @aroundRender () =>
      @afterRender()
      if(@allFetched())
        this.$('.more').hide()


