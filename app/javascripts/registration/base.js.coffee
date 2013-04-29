CommonPlace.registration.Router = Backbone.Router.extend(
  routes:
    "": "new_user"
    "/": "new_user"
    "new": "new_user"
    "*p": "new_user"
    "register/address?:params": "address"
    "register/address": "address"

  initialize: (options) ->
    @initFacebook()
    header = new CommonPlace.shared.HeaderView(el: $("#header"))
    header.render()
    @modal = new CommonPlace.registration.RegistrationModal(
      communityExterior: options.communityExterior
      template: "registration.modal"
      complete: ->
        $redirect = $("#login_redirect")
        if $redirect and $redirect.val() isnt undefined
          if $redirect.val() is window.location.href
            window.location.reload(true)
          else
            window.location = $redirect.val()
        else
          if Modernizr.history
            window.location.pathname = options.communityExterior.links.tour
          else
            window.location.href = window.location.protocol + "//" + window.location.host + "/" + options.communityExterior.slug + "/#" + options.communityExterior.slug + "/tour"

      el: $("#registration-modal")
    )
    @modal.render()

  new_user: (c) ->
    if window.location.pathname.split("/").length > 2
      url = window.location.pathname.split("/")[2]
      if url is "about" or url is "our-mission" or url is "our-story" or url is "our-platform" or url is "press" or url is "nominate" or url is "civicart"
        @new_user_about()
      else
        @modal.showPage "new_user"
    else
      @modal.showPage "new_user"

  new_user_about: (c) ->
    @modal.showPage "new_user_about"

  address: ->
    @modal.showPage "address"

  initFacebook: ->
    e = document.createElement("script")
    e.src = document.location.protocol + "//connect.facebook.net/en_US/all.js"
    e.async = true
    document.getElementById("fb-root").appendChild e
)

CommonPlace.registration.RegistrationModal = CommonPlace.View.extend(
  id: "registration-modal"
  events:
    "click #modal-whiteout": "exit"

  afterRender: ->
    @communityExterior = @options.communityExterior
    @firstSlide = true

  showPage: (page, data) ->
    self = this
    nextPage = (next, data) ->
      self.showPage next, data

    slideIn = (el, callback) ->
      self.slideIn el, callback

    #@slideOut()  unless @firstSlide
    view = {
      new_user: ->
        new CommonPlace.registration.NewUserView(
          nextPage: nextPage
          slideIn: slideIn
          communityExterior: self.communityExterior
          data: data
        )

      new_user_about: ->
        new CommonPlace.registration.AboutPageRegisterNewUserView(
          nextPage: nextPage
          slideIn: slideIn
          communityExterior: self.communityExterior
          data: data
        )

      address: ->
        new CommonPlace.registration.AddressView(
          nextPage: nextPage
          data: data
          #slideIn: slideIn
          communityExterior: self.communityExterior
          complete: self.options.complete
        )

      affiliation: ->
        new CommonPlace.registration.AffiliationView(
          nextPage: nextPage
          data: data
          #slideIn: slideIn
          communityExterior: self.communityExterior
          complete: self.options.complete
        )

    }[page]()
    _kmq.push(['record', 'Registration: ' + page + ' page', {'community': self.communityExterior.name}]) if _kmq?
    view.render()

  centerEl: ->
    $el = @$("#current-registration-page")
    $el.css @dimensions($el)

  slideOut: ->
    $current = @$("#current-registration-page")
    dimensions = @dimensions($current)
    @slide $current,
      left: 0 - $current.width()
    , ->
      $current.empty()
      $current.hide()

  slideIn: (el, callback) ->
    $next = @$("#next-registration-page")
    $window = $(window)
    $current = @$("#current-registration-page")
    $pagewidth = @$("#pagewidth")
    $pagewidth.css top: $(@el).offset().top
    $next.show()
    $next.append el
    dimensions = @dimensions($next)
    $next.css left: $window.width()
    @slide $next,
      left: dimensions.left
    , _.bind(->
      $current.html $next.children("div").detach()
      $current.show()
      @centerEl()
      $next.empty()
      $next.hide()
      callback()  if callback
    , this)

  slide: ($el, ending, complete) ->
    if @firstSlide
      $el.css ending
      @firstSlide = false
      return complete()
    $el.animate ending, 800, complete

  dimensions: ($el) ->
    left = ($(window).width() - $el.width()) / 2
    left: left

  exit: ->
    $(@el).remove()
)

CommonPlace.registration.RegistrationModalPage = CommonPlace.View.extend(
  initialize: (options) ->
    @data = options.data or isFacebook: false
    @communityExterior = options.communityExterior
    @slideIn = options.slideIn
    @nextPage = options.nextPage
    @complete = options.complete
    @template = @facebookTemplate  if options.data and options.data.isFacebook and @facebookTemplate

  showError: ($el, $error, message) ->
    $el.addClass "input_error"
    $error.text message
    $error.show()

  validate_registration: (params, callback) ->
    validate_api = "/api" + @communityExterior.links.registration.validate
    $.getJSON validate_api, @data, _.bind((response) ->
      @$(".error").hide()
      valid = true
      unless _.isEmpty(response.facebook)
        window.location.pathname = @communityExterior.links.facebook_login
      else
        _.each params, _.bind((field) ->
          unless _.isEmpty(response[field])
            error = @$(".error." + field)
            input = @$("input[name=" + field + "]")
            errorText = _.reduce(response[field], (a, b) ->
              a + " and " + b
            )
            input.addClass "input_error"
            error.text errorText
            error.show()
            valid = false
        , this)
        callback()  if valid and callback
    , this)
)
