CommonPlace.shared.DirectoryLists = CommonPlace.View.extend(
  id: "directory"

  events:
    "mouseover .scroll": "showScrollBar"
    "mouseout .scroll" : "hideScrollBar"

  initialize: ->
    @lists =
      pages: CommonPlace.community.grouplikes
      users: CommonPlace.community.featuredUsers

    self = this
    @nextPageTrigger()
    @page = 0
    @$("#directory_results").scroll ->
      st = $(this).scrollTop()
      self.nextPageThrottled()  if $(this).scrollTop() + 10 > @scrollHeight / 3


  showList: (list_name, options) ->
    @page = 0
    @nextPageTrigger()
    list = @lists[list_name]
    if list and @currentList isnt list
      @clearSearch(false)
      @$("#directory_results ul").empty()  if not options or not options.nextPage
      @currentList = list
      @currentListName = list_name
      @fetchAndRenderCurrentList options

  hideFailedSearch: ->
    @$("#directory_failed_search").hide()

  showSearch: (search_term, options) ->
    @hideFailedSearch()
    @page = 0
    if @currentListName is "users"
      @currentList = CommonPlace.community.users
    else
      @currentList = @lists[@currentListName]
    @currentQuery = search_term
    @fetchAndRenderCurrentSearch options

  renderCurrentList: (options) ->
    self = this
    @removeListSpinner()
    views = @currentList.map((item) ->
      new CommonPlace.shared.DirectoryListItem(model: item)
    )
    _.invoke views, "render"
    $results = @$("#directory_results ul")
    $results.empty()  if not options or not options.nextPage
    $results.append _.pluck(views, "el")

  fetchAndRenderCurrentList: (options) ->
    _render = _.bind(->
      @renderCurrentList options
    , this)
    @showListSpinner()
    @currentList.fetch success: _render

  fetchAndRenderCurrentSearch: (options) ->
    @showListSpinner()
    @currentList.fetch
      data:
        query: @currentQuery

      success: _.bind(->
        @$("#directory_failed_search").show()  if @currentList.length is 0
        @renderCurrentList options
        @options.removeSearchSpinner()
      , this)

  clearSearch: (refresh) ->
    @$("#directory_search input.search").val ""
    @hideFailedSearch()
    @currentQuery = ""
    @$("#directory_results ul").empty()
    if @currentListName and refresh
      @currentList = @lists[@currentListName]
      @fetchAndRenderCurrentList()

  nextPageTrigger: ->
    self = this
    @nextPageThrottled = _.once(->
      self.nextPage()
    )

  nextPage: ->
    return  if @currentList.length < 25
    @page++
    @currentList.fetch
      data:
        query: @currentQuery
        page: @page

      success: _.bind(->
        @renderCurrentList nextPage: true
        @nextPageTrigger()
      , this)
      error: _.bind(->
        @nextPageTrigger()
      , this)


  showListSpinner: ->
    @$(".loading-list").show()

  removeListSpinner: ->
    @$(".loading-list").hide()

  showScrollBar: (e) ->
    e.preventDefault()
    @$(e.currentTarget).css({"overflow-y": "auto"})

  hideScrollBar: (e) ->
    e.preventDefault()
    @$(e.currentTarget).css({"overflow": "hidden"})
)
