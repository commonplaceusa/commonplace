CommonPlace.main.CommunityResources = CommonPlace.View.extend(
  template: "main_page.community-resources"
  id: "community-resources"
  events:
    "submit .sticky form": "search"
    "keyup .sticky input": "debounceSearch"
    "click .sticky .cancel": "cancelSearch"

  initialize: ->
    _.bindAll(this, "debounceSearch")
    @eventAggregator.bind("searchBox:submit", @debounceSearch)

  afterRender: ->
    self = this
    @searchForm = new @SearchForm()
    @searchForm.render()
    $(@searchForm.el).prependTo @$(".sticky")
    $('#main').height($(document).height())

  changeSearchText: (text) ->
    search = $("#search-header")
    @cancelSearch()
    search_text = "Search " + CommonPlace.community.get("name").trim() + "..."
    if text
      search_text = "Search " + text.trim() + "..."
      search.attr "placeholder", "Search " + text.trim() + "..."
    search.attr("placeholder", search_text)
    if $.fn.placeholder.input
      search.attr("value", '')
    else
      #if the browser doesnt support placeholders, set the value of the search input to the placeholder text
      search.attr("value", search_text)

  switchTab: (tab, single) ->
    self = this
    @view = @tabs[tab](this)
    $(".wire_filter").removeClass "current"
    $("#"+tab).addClass "current"
    category = $("#"+tab).text()
    @changeSearchText category
    @$(".search-switch").removeClass "active"
    if _.include(["users", "groups", "feeds"], tab)
      @$(".directory-search").addClass "active"
    else
      @$(".post-search").addClass "active"
    @view.singleWire single  if single
    if (self.currentQuery)
      self.search()
    else
      self.showTab()
      _kmq.push(['record', 'Wire Engagement', { 'Type': 'Tab', 'Tab': tab }]) if _kmq?

  winnowToCollection: (collection_name) ->
    self = this
    @view = @tabs[collection_name](this)
    @$(".search-switch").removeClass "active"
    @$(".post-search").addClass "active"  if _.include([], collection_name)
    (if (self.currentQuery) then self.search() else self.showTab())

  showTab: ->
    $resources = @$(".resources")
    $resources.css('filter', 'alpha(opacity=20)')
    $resources.fadeOut 500, _.bind(->
      $resources.html @loading()
      self = this
      @view.resources (wire) ->
        wire.render()
        $resources = @$(".resources")
        $resources.html wire.el
        $resources.css('filter', 'alpha(opacity=20)')
        $(".resources").fadeIn 900
    , @)

  tabs:
    all_posts: (self) ->
      wire = new self.PostLikeWire(
        template: "main_page.post-resources"
        emptyMessage: "No posts here yet."
        collection: CommonPlace.community.postlikes
      )
      self.makeTab wire

    posts: (self) ->
      wire = new self.PostLikeWire(
        template: "main_page.post-resources"
        emptyMessage: "No posts here yet."
        collection: CommonPlace.community.posts
        isInAllWire: false
      )
      self.makeTab wire

    neighborhood: (self) ->
      wire = new self.PostLikeWire(
        template: "main_page.post-resources"
        emptyMessage: "No posts here yet."
        collection: CommonPlace.community.categories["neighborhood"]
      )
      self.makeTab wire

    help: (self) ->
      wire = new self.PostLikeWire(
        template: "main_page.post-resources"
        emptyMessage: "No posts here yet."
        collection: CommonPlace.community.categories["help"]
      )
      self.makeTab wire

    questions: (self) ->
      wire = new self.PostLikeWire(
        template: "main_page.post-resources"
        emptyMessage: "No posts here yet."
        collection: CommonPlace.community.categories["offers"]
      )
      self.makeTab wire

    publicity: (self) ->
      wire = new self.PostLikeWire(
        template: "main_page.post-resources"
        emptyMessage: "No posts here yet."
        collection: CommonPlace.community.categories["publicity"]
      )
      self.makeTab wire

    other: (self) ->
      wire = new self.PostLikeWire(
        template: "main_page.post-resources"
        emptyMessage: "No posts here yet."
        collection: CommonPlace.community.categories["other"]
      )
      self.makeTab wire

    events: (self) ->
      wire = new self.PostLikeWire(
        template: "main_page.event-resources"
        emptyMessage: "No events here yet."
        collection: CommonPlace.community.events
      )
      self.makeTab wire

    announcements: (self) ->
      wire = new self.PostLikeWire(
        template: "main_page.announcement-resources"
        emptyMessage: "No announcements here yet."
        collection: CommonPlace.community.announcements
      )
      self.makeTab wire

    transactions: (self) ->
      wire = new self.PostLikeWire(
        template: "main_page.transaction-resources"
        emptyMessage: "No items here yet."
        collection: CommonPlace.community.transactions
      )
      self.makeTab wire

    discussions: (self) ->
      wire = new self.PostLikeWire(
        template: "main_page.group-post-resources"
        emptyMessage: "No posts here yet."
        collection: CommonPlace.community.groupPosts
      )
      self.makeTab wire

    groups: (self) ->
      wire = new self.GroupLikeWire(
        template: "main_page.directory-resources"
        emptyMessage: "No groups here yet."
        collection: CommonPlace.community.groups
        active: "groups"
      )
      self.makeTab wire

    feeds: (self) ->
      wire = new self.GroupLikeWire(
        template: "main_page.directory-resources"
        emptyMessage: "No feeds here yet."
        collection: CommonPlace.community.feeds
        active: "feeds"
      )
      self.makeTab wire

    users: (self) ->
      wire = new self.GroupLikeWire(
        template: "main_page.directory-resources"
        emptyMessage: "No users here yet."
        collection: CommonPlace.community.users
        active: "users"
      )
      self.makeTab wire

  showPost: (post) ->
    self = this
    post.fetch success: ->
      self.showSingleItem post, Posts,
        template: "main_page.post-resources"
        tab: "posts"

  showFeedPage: (feed_slug) ->
    $.getJSON("/api/feeds/" + feed_slug, _.bind((response) ->
      feed = new Feed(response)
      wire = new @PostLikeWire(
        template: "main_page.announcement-resources"
        emptyMessage: "No announcements here yet."
        collection: feed.announcements
      )
      wire.searchPage feed
      @changeSearchText feed.get("name")
      @view = @makeTab wire
      @showTab()
    , @))

  showGroupPage: (group_id) ->
    $.getJSON("/api/groups/" + group_id, _.bind((response) ->
      group = new Group(response)
      wire = new @PostLikeWire(
        template: "main_page.announcement-resources"
        emptyMessage: "No announcements here yet."
        collection: group.posts
      )
      wire.searchPage group
      @changeSearchText group.get("name")
      @view = @makeTab wire
      @showTab()
    , @))

  showAnnouncement: (announcement) ->
    self = this
    announcement.fetch success: ->
      self.showSingleItem announcement, Announcements,
        template: "main_page.announcement-resources"
        tab: "announcements"

  showEvent: (event) ->
    self = this
    event.fetch success: ->
      self.showSingleItem event, Events,
        template: "main_page.event-resources"
        tab: "events"

  showTransaction: (transaction) ->
    self = this
    transaction.fetch success: ->
      self.showSingleItem transaction, Transactions,
        template: "main_page.transaction-resources"
        tab: "transactions"

  showGroupPost: (post) ->
    self = this
    post.fetch success: ->
      self.showSingleItem post, GroupPosts,
        template: "main_page.group-post-resources"
        tab: "discussions"

  highlightSingleUser: (user) ->
    @singleUser = user

  showSingleItem: (model, kind, options) ->
    @model = model
    @isSingle = true
    self = this
    wire = new LandingPreview(
      template: options.template
      collection: new kind([model],
        uri: model.link("self")
      )
    )
    unless _.isEmpty(@singleUser)
      wire.searchUser @singleUser
      @singleUser = {}
    @switchTab options.tab, wire
    $(window).scrollTo 0

  showUserWire: (user) ->
    self = this
    user.fetch success: ->
      collection = new PostLikes([],
        uri: user.link("postlikes")
      )
      wire = new Wire(
        template: "main_page.user-wire-resources"
        collection: collection
        emptyMessage: "No posts here yet."
      )
      wire.searchUser user
      self.switchTab "posts", wire
      $(window).scrollTo 0


  debounceSearch: _.debounce(->
    @search()
  , CommonPlace.autoActionTimeout)
  search: (event) ->
    @currentQuery = @eventAggregator.query
    if @currentQuery
      @view.search @currentQuery
      @showTab()
    else
      @cancelSearch()

  cancelSearch: (e) ->
    @currentQuery = ""
    @$(".sticky form.search input").val ""
    @view.cancelSearch()
    @showTab()
    $(".sticky form.search input").removeClass "active"
    $(".sticky .cancel").hide()
    $(".resources").removeHighlight()

  makeTab: (wire) ->
    new @ResourceTab(wire: wire)

  loading: ->
    view = new @LoadingResource()
    view.render()
    view.el

  PostLikeWire: Wire.extend(_defaultPerPage: 15)
  GroupLikeWire: Wire.extend(_defaultPerPage: 50)
  ResourceTab: CommonPlace.View.extend(
    initialize: (options) ->
      @wire = options.wire

    resources: (callback) ->
      (if (@single) then callback(@single) else callback(@wire))

    search: (query) ->
      @single = null  if @single
      @wire.search query

    singleWire: (wire) ->
      @single = wire

    cancelSearch: ->
      @search ""
  )
  SearchForm: CommonPlace.View.extend(
    template: "main_page.community-search-form"
    tagName: "form"
    className: "search"
  )
  LoadingResource: CommonPlace.View.extend(
    template: "main_page.loading-resource"
    className: "loading-resource"
  )
)
