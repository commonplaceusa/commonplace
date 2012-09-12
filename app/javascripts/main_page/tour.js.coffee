CommonPlace.main.TourModal = CommonPlace.View.extend(
  id: "main"
  tagName: "div"
  overlayLevel: 1000
  changedElements: []

  events:
    "click a.end-tour": "end"
    "click #profile-box, #community-resources, #post-box": "end"

  initialize: (options) ->
    @account = options.account
    @community = options.community
    @firstSlide = true

  render: ->
    @$("#tour").html(@renderTemplate("main_page.tour.wire", this)).attr "class", "wire"
    $(@el).append("<div id='tour-shadow'></div>")
    $(@el).append(@renderTemplate("main_page.tour.modal", this))
    $("body").css(overflow: "hidden") #prevents the main page from scrolling during the tour
    $("#current-registration-page").css(overflow: "auto")

  community_name: ->
    @community.get "name"

  first_name: ->
    @account.get "short_name"

  showPage: (page, data) ->
    self = this
    nextPage = (next, data) ->
      self.showPage next, data

    fadeIn = (el, callback) ->
      self.fadeIn el, callback

    @fadeOut()  unless @firstSlide
    view = {
      welcome: ->
        new CommonPlace.main.WelcomeView(
          nextPage: nextPage
          data: data
          fadeIn: fadeIn
          community: self.community
          account: self.account
        )

      profile: ->
        new CommonPlace.main.ProfileView(
          nextPage: nextPage
          data: data
          fadeIn: fadeIn
          community: self.community
          account: self.account
        )

      feed: ->
        new CommonPlace.main.SubscribeView(
          nextPage: nextPage
          fadeIn: fadeIn
          community: self.community
          account: self.account
          data: data
          complete: self.options.complete
        )

      rules: ->
        new CommonPlace.main.RulesView(
          nextPage: nextPage
          fadeIn: fadeIn
          community: self.community
          account: self.account
          data: data
          complete: self.options.complete
        )

      neighbors: ->
        new CommonPlace.main.NeighborsView(
          complete: self.options.complete
          fadeIn: fadeIn
          community: self.community
          account: self.account
          data: data
          nextPage: nextPage
        )
    }[page]()
    view.render()

  welcome: ->
    @showPage "welcome"

  end: ->
    $("#tour-shadow").remove()
    $("#tour").remove()

  centerEl: ($el) ->
    $el.css @dimensions($el)
    w_height = $(window).height()
    el_height = $el.height()
    el_offset = $el.offset().top
    if (el_offset + el_height) > w_height
      $el.css(overflow: "auto")
      $el.height(w_height - el_offset)

  fadeOut: ->
    $current = @$("#current-tour-page")
    $current.css('filter', 'alpha(opacity=40)')
    $current.fadeOut "slow"
    , ->
      $current.empty()
      $current.hide()

  fadeIn: (el, callback) ->
    $next = @$("#next-tour-page")
    $current = @$("#current-tour-page")
    $tour = @$("#tour")
    $next.append el
    $next.css('filter', 'alpha(opacity=40)')
    @centerEl($next)
    $next.fadeIn "slow"
    , _.bind(->
      $current.html $next.children("div").detach()
      @centerEl($current)
      $current.show()
      $next.empty()
      $next.hide()
      callback()  if callback
    , this)

  dimensions: ($el) ->
    left = ($(window).width() - $el.width())/ 2
    left: left

  exit: ->
    $(@el).remove()
)

CommonPlace.main.TourModalPage = CommonPlace.View.extend(
  initialize: (options) ->
    @data = options.data or isFacebook: false
    @community = options.community
    @account = options.account
    @fadeIn = options.fadeIn
    @nextPage = options.nextPage
    @complete = options.complete
    @template = @facebookTemplate  if options.data and options.data.isFacebook and @facebookTemplate
)
