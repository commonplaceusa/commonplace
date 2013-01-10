CommonPlace.shared.YourPages = CommonPlace.View.extend
  template: "shared.sidebar.your-pages"
  id      : "your-pages-links"

  events:
    "click .page_link": "clickPage"

  initialize: ->
    @feed_subscriptions = CommonPlace.account.get("feed_subscriptions")
    @group_subscriptions = CommonPlace.account.get("group_subscriptions")
    @nextPageTrigger()
    @page = 0

    @eventAggregator.bind("loadPages:scroll", @nextPageThrottled)

    @fetchPageList CommonPlace.community.feeds, _.bind((feeds) ->
        @feeds = feeds
      , this)

    @fetchPageList CommonPlace.community.groups, _.bind((groups) ->
        @groups = groups
      , this)

  nextPageTrigger: ->
    self = this
    this.nextPageThrottled = _.once(() ->
      self.nextPage()
    )

  nextPage: ->
    if @feeds.length < 25
      return

    @page++
    @feeds.fetch({
      data: {
        page: @page
      },
      success: _.bind(() ->
        @addPageLinks(page, @feed_subscriptions, false) for page in @feeds.models
        @nextPageTrigger()
        @eventAggregator.bind("loadPages:scroll", @nextPageThrottled)
      , this),
      error: _.bind(() ->
        @nextPageTrigger()
      , this)
    })

  afterRender: (params) ->
    self = this
    if @feeds
      @addPageLinks(page, @feed_subscriptions, false) for page in @feeds.models
    else
      @fetchPageList CommonPlace.community.feeds, _.bind((data) ->
          @addPageLinks(page, self.feed_subscriptions, false) for page in data.models
          @feeds = data
        , this)

    if @groups
      @addPageLinks(page, @group_subscriptions, true) for page in @groups.models
    else
      @fetchPageList CommonPlace.community.groups, _.bind((data) =>
          @addPageLinks(page, self.group_subscriptions, true) for page in data.models
          @groups = data
        , this)

  fetchPageList: (list, callback) ->
    list.fetch
      success: (data) ->
        if callback
          callback(data)

  addPageLinks: (data, subscriptions, subscriptions_only) ->
    page = data.toJSON()
    page.about.trim() if page.about isnt null
    if Modernizr.history
      page.url = "/" + CommonPlace.community.get("slug") + page.url
    else
      page.url = CommonPlace.community.get("slug") + page.url #for IE to handle routing properly
    html = this.renderTemplate("shared.sidebar.page", page)
    if page.id in subscriptions
      this.$('#your-pages-list').prepend html
    else if not subscriptions_only
      this.$('#your-pages-list').append html

  clickPage: (e) ->
    e.preventDefault() if e
    $(".current").removeClass("current")
    $(e.currentTarget).parent().addClass("current")
    _kmq.push(['record', 'Clicked Directory Page', {"Page Name": e.currentTarget.innerText}]) if _kmq?
