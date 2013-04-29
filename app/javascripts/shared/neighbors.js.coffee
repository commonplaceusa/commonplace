CommonPlace.shared.Neighbors = CommonPlace.View.extend
  template: "shared.sidebar.neighbors"

  events:
    "click .neighbor_link": "clickNeighbor"

  initialize: ->
    CommonPlace.community.featuredUsers.fetch
      success: _.bind((neighbors) ->
        @neighbors = neighbors
      , this)

    @nextPageTrigger()
    @page = 0

    @eventAggregator.bind("loadNeighbors:scroll", @nextPageThrottled)

  nextPageTrigger: ->
    self = this
    this.nextPageThrottled = _.once(() ->
      self.nextPage()
    )

  nextPage: ->
    if @neighbors.length < 25
      return

    @page++
    @neighbors.fetch({
      data: {
        page: @page
      },
      success: _.bind(() ->
        @showNeighbors @neighbors
        @nextPageTrigger()
        @eventAggregator.bind("loadNeighbors:scroll", @nextPageThrottled)
      , this),
      error: _.bind(() ->
        @nextPageTrigger()
      , this)
    })

  afterRender: () ->
    if @neighbors
      @showNeighbors @neighbors
    else
      CommonPlace.community.featuredUsers.fetch
        success: _.bind((neighbors) ->
          @showNeighbors neighbors
          @neighbors = neighbors
        , this)

  showNeighbors: (neighbors) ->
    neighbors.each (n) =>
      neighbor = n.toJSON()
      neighbor.about.trim() if neighbor.about isnt null
      if Modernizr.history
        neighbor.url = '/' + CommonPlace.community.get("slug") + '/show' + neighbor.url
      else
        neighbor.url = CommonPlace.community.get("slug") + '/show' + neighbor.url #for IE to handle routing properly
      html = this.renderTemplate("shared.sidebar.neighbor", neighbor)
      this.$(".list").append html

  clickNeighbor: (e) ->
    e.preventDefault() if e
    $(".current").removeClass("current")
    $(e.currentTarget).parent().addClass("current")
    _kmq.push(['record', 'Clicked Directory Neighbor', {"Neighbor": e.currentTarget.innerText}]) if _kmq?
