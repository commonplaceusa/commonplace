CommonPlace.shared.HeaderLogin = CommonPlace.View.extend(
  template: "shared.new_header.header-login"
  id: "user_sign_in"
  tagName: "ul"
  events:
    "click #login": "toggleLogin"
    "click button[name=signin]": "login"
    "click signin_button": "login"
    "submit form": "login"

  afterRender: ->
    @$("#sign_in").hide()
    @$("input[placeholder]").placeholder()

  toggleLogin: (e) ->
    e.preventDefault()  if e
    @$("#sign_in").toggle()

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
