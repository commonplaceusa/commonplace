CommonPlace.main.EmailView = CommonPlace.main.TourModalPage.extend(
  template: "main_page.tour.email"
  events:
    "click input.continue": "submit"
    "submit form": "submit"
    "click img.facebook": "facebook"
    "click .next-button": "submit"

  afterRender: ->
    @hideSpinner()
    @$("input[placeholder]").placeholder()
    @$("input:visible:first").focus() if @browserSupportsPlaceholders() and $.browser.webkit #only focus the first input if the browser supports placeholders and is webkit based (others clear the placeholder on focus)
    @fadeIn @el
    if @data and @data.isFacebook
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

  isRealEmail: ->
    return false  if not @data or not @data.email
    @data.email.search("proxymail") is -1

  facebook: (e) ->
    e.preventDefault()  if e
    facebook_connect_registration success: _.bind((data) ->
      @data = data
      @data.isFacebook = true
      @nextPage "profile", @data
    , this)

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
      @showSpinner()
      params = [ "full_name", "email" ]
      @validate_registration params, _.bind(->
        if CommonPlace.community.get("slug").toLowerCase() is "harvardneighbors"
          @nextPage "affiliation", @data
        else
          @nextPage "address", @data
      , this)

)
