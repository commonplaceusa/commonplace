CommonPlace.shared.HeaderSearch = CommonPlace.View.extend(
  template: "shared.new_header.header-search"
  className: "header_search"

  events:
    "keyup #search-header": "search"

  afterRender: ->
    @$("input[placeholder], textarea[placeholder]").placeholder()

  search: (event) ->
    @query = @$("#search-header").val()
    @eventAggregator.query = @query
    @eventAggregator.trigger("searchBox:submit", @query)
)
