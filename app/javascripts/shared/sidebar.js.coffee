CommonPlace.shared.Sidebar = CommonPlace.View.extend
  template          : "shared.sidebar"
  id                : "sidebar"
  links_header_class: "sidebar-links"
  content_div       : "directory_content"

  events:
    "click .sidebar-links": "switchTabs"
    "mouseover .scroll": "showScrollBar"
    "mouseout .scroll": "hideScrollBar"

  initialize: (options) ->
    @tabs = options.tabs
    @tabviews = options.tabviews
    @nav = options.nav
    @options = options

  afterRender: ->
    self = this
    this.$("#directory_content").scroll ->
      self.eventAggregator.trigger("loadPages:scroll")  if $(this).scrollTop() + 10 > @scrollHeight / 2
    @nav.render()
    @$("#your-town").replaceWith(@nav.el)

    @showTab(@tabs[0].title)
    $(window).resize(_.bind(@resizeDirectory, this))

  avatar_url: ->
    @options.avatar_url

  switchTabs: (e) ->
    e.preventDefault()
    self = this
    title = @$(e.currentTarget).attr("title")
    this.$("#directory_content").unbind("scroll")
    if title == "pages"
      this.$("#directory_content").scroll ->
        self.eventAggregator.trigger("loadPages:scroll")  if $(this).scrollTop() + 10 > @scrollHeight / 2
    else
      this.$("#directory_content").scroll ->
        self.eventAggregator.trigger("loadNeighbors:scroll")  if $(this).scrollTop() + 10 > @scrollHeight / 2
    @showTab(title)

  showTab: (title) ->
    if title of @tabviews
      @$('.sidebar-links').removeClass('current_tab')
      @$('[title="'+title+'"]').addClass('current_tab')
      view = @tabviews[title]
      view.render()
      @$("#"+@content_div).html(view.el)
      @resizeDirectory()

  resizeDirectory: ->
    height = 0
    body = window.document.body
    if window.innerHeight isnt undefined
      height = window.innerHeight
    else if body.parentElement.clientHeight isnt undefined
      height = body.parentElement.clientHeight
    else if body and body.clientHeight
      height = body.clientHeight

    offset = @$("#"+@content_div).offset()
    if offset.top is 0
      directory_height = height - 308
    else
      directory_height = height - offset.top - 15
    @$("#"+@content_div).height(directory_height+"px")

  showScrollBar: (e) ->
    e.preventDefault()
    @$(e.currentTarget).css({"overflow-y": "auto"})

  hideScrollBar: (e) ->
    e.preventDefault()
    @$(e.currentTarget).css({"overflow": "hidden"})

