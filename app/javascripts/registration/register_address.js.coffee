CommonPlace.registration.AddressView = CommonPlace.registration.RegistrationModalPage.extend(
  template: "registration.address"
  events:
    "click input.continue": "submit"
    "submit form": "submit"
    "click .next-button": "submit"

  afterRender: ->
    @hasAvatarFile = false
    @initReferralQuestions()
    @$("select.dk").dropkick()
    $("#current-registration-page").html @el
    @$("input[placeholder]").placeholder()
    url = "/api/communities/" + @communityExterior.id + "/address_completions"
    @$("input[name=address]").autocomplete
      source: url
      minLength: 1
      autoFocus: true

  user_name: ->
    (if (@data.full_name) then @data.full_name.split(" ")[0] else "")

  showAddressError: (message) ->
    address = @$("input[name=address]")
    error = @$(".error.address")
    address.addClass "input_error"
    error.text message
    error.show()

  showReferralSourceError: (message) ->
    referral = @$("select[name=referral_source]")
    error = @$(".error.referral_source")
    referral.addClass "input_error"
    error.text message
    error.show()

  showReferralMetaError: (message) ->
    referral = @$("select[name=referral_metadata]")
    error = @$(".error.referral_metadata")
    referral.addClass "input_error"
    error.text message
    error.show()

  submit: (e) ->
    e.preventDefault()  if e
    @$(".error").hide()
    @data.address = @$("input[name=address]").val()
    @data.referral_source = @$("select[name=referral_source]").val()
    @data.referral_metadata = @$("input[name=referral_metadata]").val()
    @data.organizations = ""

    if @data.address.length < 1
      @showAddressError "Please enter a valid address"
      return

    if @data.referral_source is "placeholder"
      @showReferralSourceError "Please tell us how you heard about OurCommonPlace"
      return

    if @$("#address_verification").is(":hidden")
      @data.term = @data.address

      url = '/api/communities/' + @communityExterior.id + '/address_approximate'
      $.get url, @data, _.bind((response) ->
        div = @$("#address_verification")
        radio = @$("input.address_verify_radio")
        span = @$("span.address_verify_radio")
        addr = @$("#suggested_address")
        weight = parseFloat(response[0])

        if weight != -1
          if response[1].length < 1 || weight < 0.84
            @showAddressError "Please enter a valid address"
            return
          else if weight < 0.94
            @data.suggest = response[1]

            addr.empty()
            addr.text(response[1])

            div.show()
            radio.show()
            span.show()
            addr.show()
            return
          else
            @data.address = response[1]
            @verified()
        else
          @verified()
      , this)
    else
      if @$("#suggested").is(':checked')
        @data.address = @data.suggest

      @verified()

  verified: ->
    new_api = "/api" + @communityExterior.links.registration[(if (@data.isFacebook) then "facebook" else "new")]
    $.post new_api, @data, _.bind((response) ->
      if response.success is "true" or response.id
        CommonPlace.account = new Account(response)
        if @hasAvatarFile and not @data.isFacebook
          @avatarUploader.submit()
        else
          delete @data.term
          delete @data.suggest
          @complete()
      else
        unless _.isEmpty(response.facebook)
          window.location.pathname = @communityExterior.links.facebook_login
        else unless _.isEmpty(response.password)
          @$(".error").text response.password[0]
          @$(".error").show()
    , this)

  referrers: ->
    @communityExterior.referral_sources

  initReferralQuestions: ->
    @$("select[name=referral_source]").bind "change", _.bind(->
      question =
        "At a table or booth at an event": "What was the event?"
        "In an email": "Who was the email from?"
        "On Facebook or Twitter": "From what person or organization?"
        "On another website": "What website?"
        "In the news": "From which news source?"
        "Word of mouth": "From what person or organization?"
        "Flyer from a business or organization": "Which business or organization?"
        Other: "Where?"
      [@$("select[name=referral_source] option:selected").val()]
      if question
        @$("input[name=referral_metadata]").attr("placeholder", question)
        @$("#referral_metadata").show()
      else
        @$("#referral_metadata").hide()
    , this)
)
