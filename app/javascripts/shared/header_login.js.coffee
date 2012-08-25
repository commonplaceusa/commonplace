CommonPlace.shared.HeaderLogin = CommonPlace.View.extend(
  template: "shared.new_header.header-login"
  id: "user_sign_in"
  tagName: "ul"
  events:
    "click #login": "toggleLogin"
    "click button[name=signin]": "login"
    "submit form": "login"

  afterRender: ->
    @$("#sign_in").hide()
    @$("#choose_town").hide()
    #append the links to the towns in the $("#town_list")

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
      @$("#errors").append @create_error("Please enter an e-mail address")
      @$("input[name=email]").addClass "error"
      return
    password = @$("input[name=password]").val()
    unless password
      @$("#errors").append @create_error("Please enter a password")
      @$("input[name=password]").addClass "error"
      return
    $.postJSON
      url: "/api/sessions"
      data:
        email: email
        password: password

      success: ->
        window.location = "/users/sign_in"

      error: _.bind(->
        window.location = "/login_failed"
      , this)

)
