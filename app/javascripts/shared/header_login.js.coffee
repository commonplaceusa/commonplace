CommonPlace.shared.HeaderLogin = CommonPlace.View.extend(
  template: "shared.new_header.header-login"
  id: "user_sign_in"
  tagName: "ul"
  events:
    "click #login": "toggleLogin"
    "click #wrong_town": "toggleTown"
    "click button[name=signin]": "login"
    "submit form": "login"

  beforeRender: ->
    if CommonPlace.community and @community_slug() == 'HarvardNeighbors'
      @template = 'shared.new_header.harvard-header-login'

  afterRender: ->
    @$("#sign_in").hide()
    @$("#choose_town").hide()
    @$("input[placeholder]").placeholder()
    town_list_api = "/api/communities/marquette/comm_completions"
    $.getJSON town_list_api, _.bind((response) ->
      if response
        @$("#town_list").append("<li><a href='/#{town.slug}'>#{town.name}, #{town.state}</a></li>") for town in response
    , this)

  toggleLogin: (e) ->
    e.preventDefault()  if e
    @$("#sign_in").toggle()

  toggleTown: (e) ->
    e.preventDefault()  if e
    @$("#choose_town").toggle()

  create_error: (text) ->
    "<li class='error'>" + text + "</li>"

  login: (e) ->
    e.preventDefault()  if e
    @$(".notice").html ""
    @$(".error").removeClass "error"
    email = @$("input[name=email]").val()
    unless email
      @$("#errors").text("Please enter an e-mail address")
      @$("input[name=email]").addClass "error"
      return
    password = @$("input[name=password][type=password]").val()
    unless password
      @$("#errors").text("Please enter a password")
      @$("input[name=password][type=password]").addClass "error"
      return

    errors = @$("#errors")
    $.postJSON
      url: "/api/sessions"
      data:
        email: email
        password: password

      success: ->
        window.location = "/users/sign_in"

      error: ->
        errors.text("Your username or password is incorrect")
        errors.addClass("error")
)
