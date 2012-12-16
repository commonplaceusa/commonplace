CommonPlace.registration.NewUserView = CommonPlace.registration.RegistrationModalPage.extend(
  template: "registration.new"
  events:
    "click input.sign_up": "submit"
    "submit form": "submit"
    "click .next-button": "submit"
    "click .facebook": "facebook"

  beforeRender: ->
    if @community_slug() == 'HarvardNeighbors'
      @template = 'registration.harvard_new'

  afterRender: ->
    unless @current
      @slideIn @el
      @current = true
    tabs = @$("ul.nav-tabs > a")
    $(".tab-content > div").hide().filter("#home").fadeIn "500", "linear"
    $("ul.nav-tabs a").each ->
      tabs.push this

    @$(tabs).click ->
      $(".tab-content > div").hide().filter(@hash).fadeIn "500", "linear"
      $(tabs).removeClass "selected"
      $(this).addClass "selected"
      false

    @$("input[placeholder]").placeholder()
    if @data.isFacebook
      @$("input[name=full_name]").val @data.full_name
      @$("input[name=email]").val @data.email  if @isRealEmail()
    domains = [ "hotmail.com", "gmail.com", "aol.com", "yahoo.com" ]
    @$("input#email").blur ->
      $("input#email").mailcheck domains,
        suggested: (element, suggestion) ->
          $(".error.email").html "Did you mean " + suggestion.full + "?"
          $(".error.email").show()
          $(".error.email").click (e) ->
            $(element).val suggestion.full

        empty: (element) ->
          $(".error.email").hide()

  community_name: ->
    @communityExterior.name

  learn_more: ->
    @communityExterior.links.learn_more

  created_at: ->
    @communityExterior.statistics.created_at

  neighbors: ->
    @communityExterior.statistics.neighbors

  feeds: ->
    @communityExterior.statistics.feeds

  postlikes: ->
    @communityExterior.statistics.postlikes

  submit: (e) ->
    e.preventDefault()  if e
    @$("input").removeClass "input_error"
    @$(".error").hide()
    @data.full_name = @$("input[name=full_name]").val()
    @data.email = @$("input[name=email]").val()
    @data.password = @$("input[name=password][type=password]").val()
    if @data.password is ""
      @showError @$("input[name=password]"), @$(".error.password"), "Password can't be empty"
    else
      params = [ "full_name", "email" ]
      @validate_registration params, _.bind(->
        if this.options.communityExterior.slug == "HarvardNeighbors"
          @nextPage "affiliation", @data
        else
          @nextPage "address", @data
      , this)

  facebook: (e) ->
    e.preventDefault()  if e
    facebook_connect_registration success: _.bind((data) ->
      @data = data
      @data.isFacebook = true
      if this.options.communityExterior.slug == "HarvardNeighbors"
        @nextPage "affiliation", @data
      else
        @nextPage "address", @data
    , this)

  isRealEmail: ->
    return false  if not @data or not @data.email
    @data.email.search("proxymail") is -1

  showVideo: (e) ->
    e.preventDefault()  if e
    video = @make("iframe",
      width: 330
      height: 215
      src: "http://www.youtube.com/embed/3GIydXPH3Eo?autoplay=1"
      frameborder: 0
      allowfullscreen: true
    )
    @$("div.show-video-con").replaceWith video
)
