CommonPlace.registration.AboutPageRegisterNewUserView = CommonPlace.registration.RegistrationModalPage.extend(
  template: "registration.new_about_page"
  facebookTemplate: "registration.facebook"
  events:
    "click button.next-button": "submit"
    "submit form": "submit"
    "click img.facebook": "facebook"

  afterRender: ->
    unless @current
      @slideIn @el
      @current = true
    @$("input[placeholder]").placeholder()
    if @data.isFacebook
      @$("input[name=full_name]").val @data.full_name
      @$("input[name=email]").val @data.email  if @isRealEmail()
    domains = ["hotmail.com", "gmail.com", "aol.com", "yahoo.com"]
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
    "/" + @communityExterior.slug + "/about"

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
    @data.full_name = @$("input[name=full_name]").val()
    @data.email = @$("input[name=email]").val()
    @data.password = @$("input[name=password]").val()
    if @data.password is ""
      input = @$("input[name=password]")
      error = @$(".error.password")
      input.addClass "input_error"
      error.text "Password can't be empty"
      error.show()
    else
      params = [ "full_name", "email" ]
      @validate_registration params, _.bind(->
        @nextPage "address", @data
      , this)

  facebook: (e) ->
    e.preventDefault()  if e
    facebook_connect_registration success: _.bind((data) ->
      @data = data
      @data.isFacebook = true
      @nextPage "address", @data
    , this)

  isRealEmail: ->
    return false  if not @data or not @data.email
    @data.email.search("proxymail") is -1
)
