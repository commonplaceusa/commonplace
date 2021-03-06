CommonPlace.registration.AddressView = CommonPlace.registration.RegistrationModalPage.extend(
  template: "registration.address"
  events:
    "click input.continue": "submit"
    "submit form": "submit"
    "click .next-button": "submit"
    "click .confirm": "verified"

  afterRender: ->
    @initReferralQuestions()
    $("#current-registration-page").html @el
    @$("input[placeholder]").placeholder()
    url = "/api/communities/" + @communityExterior.id + "/address_completions"
    @$("input[name=address]").autocomplete
      source: url
      minLength: 1
      autoFocus: true

  user_name: ->
    (if (@data.full_name) then @data.full_name.split(" ")[0] else "")

  submit: (e) ->
    e.preventDefault()  if e
    @$(".error").hide()
    @data.address = @$("input[name=address]").val()
    @data.referral_source = @$("select[name=referral_source]").val()
    @data.referral_metadata = @$("input[name=referral_metadata]").val()

    if @data.address.length < 1
      @showError @$("input[name=address]"), @$(".error.address"), "Please enter a valid address"
      return

    if @data.referral_source is "placeholder"
      @showError @$("select[name=referral_source]"), @$(".error.referral_source"), "Please tell us how you heard about OurCommonPlace"
      return

    if not @$("#referral_metadata").is(":hidden") and not @data.referral_metadata
      @showError @$("select[name=referral_metadata]"), @$(".error.referral_metadata"), "Please fill out the field above. It'll give us a chance to thank who brought you aboard!"
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
            @showError @$("input[name=address]"), @$(".error.address"), "Please enter a valid address"
            @$("#bypass").show()
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
        delete @data.term
        delete @data.suggest
        @googleAdWordsConversion()
        @complete()
      else
        unless _.isEmpty(response.facebook)
          window.location.pathname = @communityExterior.links.facebook_login
        else unless _.isEmpty(response.password)
          @$(".error").text response.password[0]
          @$(".error").show()
    , this)

  googleAdWordsConversion: ->
    google_conversion_id = 978921053
    google_conversion_language = "en"
    google_conversion_format = "3"
    google_conversion_color = "ffffff"
    google_conversion_label = "lkjGCNuX-QQQ3czk0gM"
    google_conversion_value = 0
    $.getScript("http://www.googleadservices.com/pagead/conversion.js")

  referrers: ->
    @communityExterior.referral_sources

  initReferralQuestions: ->
    @$("#referral_metadata").hide()
    @$("select.dk").dropkick(
      change: _.bind((value, label)->
        question =
          "Heard about it from a friend or neighbor": "From who? We'd love to thank them!"
          "Heard about it in a news story": "Which news source? We'd love to thank them!"
          "Other": "What made you join? It'll help our effort to let us know!"
        meta = question[value]
        if meta
          @$("input[name=referral_metadata]").attr("placeholder", meta)
          @$("#referral_metadata").show()
        else
          @$("#referral_metadata").hide()
      , this)
    )
)
