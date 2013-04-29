CommonPlace.shared.Directory = CommonPlace.View.extend(
  template: "shared.directory"
  id: "directory"
  lists_div: "directory_lists"
  results_div: "directory_results"

  events:
    "click .directory_tab": "switchTab"
    "click .remove_search": "removeSearch"
    "keyup input.search"  : "search"

  afterRender: ->
    @lists = new CommonPlace.shared.DirectoryLists(
      el: @$("#"+@lists_div)
      removeSearchSpinner: _.bind(@removeSearchSpinner, this)
    )
    @showTab "pages"
    @$("[placeholder]").placeholder()
    $(window).resize(_.bind(@resizeDirectory, this))
    @resizeDirectory()
    @hideClearSearch()

  switchTabClass: (schema) ->
    @$(".directory_tab").removeClass "current_tab"
    @$("." + schema + "-filter").addClass "current_tab"

  switchTab: (e) ->
    e.preventDefault()
    return @showRegistration() if @isGuest()

    schema = $(e.target).attr("title")
    @showTab schema

  showTab: (schema) ->
    @lists.showList schema, {}
    @switchTabClass schema

  hideClearSearch: ->
    @$(".remove_search").hide()

  showClearSearch: ->
    @$(".remove_search").show()

  search: _.debounce(->
    search_term = @$("#directory_search input.search").val()
    @$(".search").addClass "loading"
    if search_term is ""
      @removeSearch()
      @removeSearchSpinner()
    else
      @showClearSearch()
      @lists.showSearch search_term, {}
      @$(".directory_tab").removeClass "current"
  , 500)

  removeSearch: ->
    @lists.clearSearch(true)
    @hideClearSearch()

  removeSearchSpinner: ->
    @$(".search").removeClass "loading"

  resizeDirectory: ->
    height = 0
    body = window.document.body
    if window.innerHeight isnt undefined
      height = window.innerHeight
    else if body.parentElement.clientHeight isnt undefined
      height = body.parentElement.clientHeight
    else if body and body.clientHeight
      height = body.clientHeight

    offset = @$("#"+@results_div).offset()
    if offset.top is 0
      directory_height = height - 345
    else
      directory_height = height - offset.top - 15
    @$("#"+@results_div).height(directory_height+"px")

)
